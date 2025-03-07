import 'package:flutter/material.dart';
import 'dart:io';

class FullScreenImage extends StatelessWidget {
  final String imagePath;

  const FullScreenImage({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(22, 183, 154, 1),
        title: const Text("My Image"),
      ),
      body: Center(
        child: Image.file(
          File(imagePath), // You need to create a File object from imagePath
          fit: BoxFit.contain, // Adjust the fit as needed
        ),
      ),
    );
  }
}
