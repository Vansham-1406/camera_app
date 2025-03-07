// ignore_for_file: file_names

import 'package:camera_app/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:camera_app/FullScreenImage.dart';
import 'dataObject.dart';

class MyDocuments extends StatefulWidget {
  const MyDocuments({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _MyDocumentsState createState() => _MyDocumentsState();
}

class _MyDocumentsState extends State<MyDocuments> {
  late List<DataObject> loadedData;
  void deleteItem(int index) async {
    loadedData.removeAt(index);
    await saveDataToLocal(loadedData);
    // Add your delete logic to delete the file from storage based on your method
    // You should implement the file deletion logic here
    // Example: File(dataItem.imagePath).delete();
    setState(() {}); // Trigger a rebuild of the UI
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 183, 154, 1),
        title: const Text("My Documents"),
        actions: [
          InkWell(
            child: const Icon(Icons.add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CameraApp()),
              );
            },
          ),
          const SizedBox(width: 10)
        ],
      ),
      body: FutureBuilder<List<DataObject>>(
        // Use FutureBuilder to load data asynchronously
        future: loadDataFromLocal(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading data: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No data available"));
          } else {
            loadedData = snapshot.data!;
            loadedData.sort((a, b) => b.date.compareTo(a.date));

            return ListView.builder(
              itemCount: loadedData.length,
              itemBuilder: (context, index) {
                final dataItem = loadedData[index];
                final formattedDate =
                    DateFormat.yMd().add_jm().format(dataItem.date);

                return GestureDetector(
                  onTap: () {
                    // Navigate to a new page to display the image in full screen
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            FullScreenImage(imagePath: dataItem.imagePath),
                      ),
                    );
                  },
                  child: Card(
                    margin: const EdgeInsets.all(8.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Image.asset(
                                "assets/jpg.png",
                                height: 50,
                              )),
                          Text(
                            formattedDate,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          InkWell(
                            child: Container(
                                padding: const EdgeInsets.only(right: 15),
                                child: const Icon(
                                  Icons.delete,
                                  color: Color.fromARGB(255, 173, 89, 83),
                                )),
                            onTap: () {
                              deleteItem(index);
                            },
                          ),
                        ]),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
