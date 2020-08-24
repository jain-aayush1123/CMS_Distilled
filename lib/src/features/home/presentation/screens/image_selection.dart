import 'dart:io';

import 'package:cms_distilled/src/features/home/presentation/screens/details_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GetImageScreen extends StatefulWidget {
  @override
  _GetImageScreenState createState() => _GetImageScreenState();
}

class _GetImageScreenState extends State<GetImageScreen> {
  File _image;
  final picker = ImagePicker();

  Future getImage(bool isCamera) async {
    final pickedFile = isCamera
        ? await picker.getImage(source: ImageSource.camera)
        : await picker.getImage(source: ImageSource.gallery);

    // final pickedFile = await picker.getImage(source: ImageSource.camera);

    setState(() {
      _image = File(pickedFile.path);
    });

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailsScreen(_image)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('Image Picker Example'),
      // ),
      body: Center(
        child: _image == null ? Text('No image selected.') : Image.file(_image),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            heroTag: "btn1",
            onPressed: () => getImage(true),
            tooltip: 'Pick Image',
            child: Icon(Icons.add_a_photo),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            heroTag: "btn2",
            onPressed: () => getImage(false),
            tooltip: 'Pick Image',
            child: Icon(Icons.photo),
          ),
        ],
      ),
    );
  }
}
