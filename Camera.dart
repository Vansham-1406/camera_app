// ignore: file_names
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dataObject.dart';
import 'main.dart';

// ignore: must_be_immutable
class Camera extends StatefulWidget {
  Camera(this.file, {Key? key}) : super(key: key);
  XFile file;
  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  late File picture = File(widget.file.path);
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 183, 154, 1),
        title: const Text("Photo"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "Do you want to crop ? ",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () async {
                      final croppedFile = await ImageCropper().cropImage(
                          sourcePath: picture.path,
                          aspectRatioPresets: Platform.isAndroid
                              ? [
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio3x2,
                                  CropAspectRatioPreset.original,
                                  CropAspectRatioPreset.ratio4x3,
                                  CropAspectRatioPreset.ratio16x9
                                ]
                              : [
                                  CropAspectRatioPreset.original,
                                  CropAspectRatioPreset.square,
                                  CropAspectRatioPreset.ratio3x2,
                                  CropAspectRatioPreset.ratio4x3,
                                  CropAspectRatioPreset.ratio5x3,
                                  CropAspectRatioPreset.ratio5x4,
                                  CropAspectRatioPreset.ratio7x5,
                                  CropAspectRatioPreset.ratio16x9
                                ],
                          uiSettings: [
                            AndroidUiSettings(
                                toolbarTitle: "Image Cropper",
                                toolbarColor: Colors.blue,
                                toolbarWidgetColor: Colors.white,
                                initAspectRatio: CropAspectRatioPreset.original,
                                lockAspectRatio: false),
                            IOSUiSettings(
                              title: "Image Cropper",
                            )
                          ]);
                      if (croppedFile != null) {
                        imageCache.clear();

                        final dataObject = DataObject(
                          date: DateTime.now(),
                          imagePath: croppedFile.path,
                        );

                        List<DataObject> existingData =
                            await loadDataFromLocal();

                        existingData.add(dataObject);

                        await saveDataToLocal(existingData);

                        setState(() {
                          imageFile = File(croppedFile.path);
                          Navigator.pushReplacementNamed(context, '/')
                              .then((_) {
                            // Reload the data when returning from CameraApp
                            setState(() {});
                          });
                        });
                      }
                    },
                    child: const Text("Edit"),
                  ),
                  TextButton(
                      style: TextButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white),
                      onPressed: () async {
                        final dataObject = DataObject(
                          date: DateTime.now(),
                          imagePath: picture.path,
                        );

                        List<DataObject> existingData =
                            await loadDataFromLocal();

                        existingData.add(dataObject);
                        await saveDataToLocal(existingData);
                        setState(() {
                          imageFile = File(picture.path);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomePage())).then((_) {
                            // Reload the data when returning from CameraApp
                            setState(() {});
                          });
                        });
                      },
                      child: const Text("No"))
                ],
              )
            ]),
      ),
    );
  }
}
