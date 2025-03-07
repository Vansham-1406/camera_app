import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DataObject {
  final DateTime date;
  final String imagePath;

  DataObject({
    required this.date,
    required this.imagePath,
  });

  // Create a constructor to convert JSON to a DataObject instance
  DataObject.fromJson(Map<String, dynamic> json)
      : date = DateTime.parse(json['date']),
        imagePath = json['imagePath'];

  // Create a method to convert DataObject to JSON
  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'imagePath': imagePath,
      };
}

// Function to save data to local storage
Future<void> saveDataToLocal(List<DataObject> dataObjects) async 
{
  final appDocDir = await getApplicationDocumentsDirectory();
  final localPath = appDocDir.path;
  const fileName = 'data.json';
  final localFile = File('$localPath/$fileName');

  final jsonData = jsonEncode(dataObjects);

  await localFile.writeAsString(jsonData);
}

// Function to load data from local storage
Future<List<DataObject>> loadDataFromLocal() async 
{
  final appDocDir = await getApplicationDocumentsDirectory();
  final localPath = appDocDir.path;
  const fileName = 'data.json';
  final localFile = File('$localPath/$fileName');

  if (await localFile.exists()) {
    final jsonData = await localFile.readAsString();
    final decodedData = jsonDecode(jsonData);

    // Convert the decoded data back into a list of DataObject instances
    final List<DataObject> dataObjects = (decodedData as List)
        .map((item) => DataObject.fromJson(item))
        .toList();

    return dataObjects;
  } else 
  {
    // Handle the case where the file doesn't exist or there's an error
    return [];
  }
}

