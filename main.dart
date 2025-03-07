// ignore_for_file: avoid_returning_null_for_void, library_private_types_in_public_api, avoid_print
import 'package:camera_app/MyDocuments.dart';
import 'package:camera_app/Camera.dart';
import 'package:camera_app/services/local_noti.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;

late List<CameraDescription> cameras;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService().initNotification();
  tz.initializeTimeZones();
  await [Permission.notification].request();
  cameras = await availableCameras();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color.fromRGBO(211, 211, 211, 1),
        appBar: AppBar(
          backgroundColor: const Color.fromRGBO(22, 183, 154, 1),
          toolbarHeight: 0,
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 20),
              height: 350,
              width: MediaQuery.of(context).size.width,
              color: const Color.fromRGBO(22, 183, 154, 1),
              child: Column(
                children: [
                  Image.asset(
                    "assets/scanner.png",
                    height: 280,
                  ),
                  const InkWell(
                    child: Text(
                      "QTPY",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.w800),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              child: Container(
                height: 80,
                color: Colors.white,
                margin: const EdgeInsets.only(top: 20),
                width: 120,
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.document_scanner_outlined,
                        size: 30,
                      ),
                      SizedBox(height: 5),
                      Text("Scanner")
                    ]),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraApp()),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              child: const Text(
                "My Documents",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  decoration: TextDecoration.underline,
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MyDocuments()),
                );
              },
            )
          ],
        ));
  }
}

class CameraApp extends StatefulWidget {
  const CameraApp({Key? key}) : super(key: key);

  @override
  _CameraAppState createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  late CameraController _controller;
  @override
  void initState() {
    super.initState();
    _controller = CameraController(cameras[0], ResolutionPreset.max);
    _controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    }).catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("Access denied");
            break;

          default:
            print(e.description);
            break;
        }
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SizedBox(
          height: double.infinity,
          child: CameraPreview(_controller),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Center(
                child: Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  shape: BoxShape.circle),
              child: MaterialButton(onPressed: () async {
                if (!_controller.value.isInitialized) {
                  return null;
                }

                if (_controller.value.isTakingPicture) {
                  return null;
                }
                try {
                  await _controller.setFlashMode(FlashMode.auto);
                  if (_controller.value.isInitialized) {
                    await _controller.setFocusMode(FocusMode.auto);
                    await Future.delayed(
                        const Duration(milliseconds: 100)); // Wait for focus

                    // Capture the image
                    final XFile file = await _controller.takePicture();
                    // ignore: use_build_context_synchronously
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Camera(file)));
                  }
                } on CameraException catch (e) {
                  debugPrint("Error occured while printing picture $e");
                  return null;
                }
              }),
            )),
            const SizedBox(height: 20)
          ],
        )
      ]),
    );
  }
}
