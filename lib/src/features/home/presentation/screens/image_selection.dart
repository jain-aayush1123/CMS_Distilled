import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:cms_distilled/src/features/home/presentation/screens/details_screen.dart';
import 'package:cms_distilled/src/utils/res/colors.dart';
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
      body: Padding(
        padding: const EdgeInsets.only(
          top: 60,
          bottom: 60,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeuButtonRound(
                title: "Select From Gallery",
                icon: Icons.photo_library,
                foo: () => getImage(false),
              ),
              Text(
                "Upload Timetable",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
              NeuButtonRound(
                title: "Capture Image",
                icon: Icons.camera,
                foo: () => getImage(true),
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: Row(
      //   mainAxisAlignment: MainAxisAlignment.center,
      //   children: [
      //     FloatingActionButton(
      //       heroTag: "btn1",
      //       onPressed: () => getImage(true),
      //       tooltip: 'Pick Image',
      //       child: Icon(Icons.add_a_photo),
      //     ),
      //     SizedBox(width: 10),
      //     FloatingActionButton(
      //       heroTag: "btn2",
      //       onPressed: () => getImage(false),
      //       tooltip: 'Pick Image',
      //       child: Icon(Icons.photo),
      //     ),
      //   ],
      // ),
    );
  }
}

class NeuButtonRound extends StatelessWidget {
  const NeuButtonRound({
    Key key,
    this.title,
    this.icon,
    this.foo,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final Function foo;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    double dim = width > height ? height : width;
    double contSize = dim * 0.5;

    return InkWell(
      onTap: foo,
      child: ClayContainer(
        color: baseColor,
        height: contSize,
        width: contSize,
        borderRadius: contSize / 2,
        curveType: CurveType.convex,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: uiColor,
              ),
              SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(color: uiColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
