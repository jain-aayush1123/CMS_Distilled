import 'dart:async';
import 'dart:io';

import 'package:cms_distilled/src/utils/text_detector_painter.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class DetailsScreen extends StatefulWidget {
  final File image;
  DetailsScreen(this.image);
  @override
  _DetailsScreenState createState() => _DetailsScreenState(image);
}

class _DetailsScreenState extends State<DetailsScreen> {
  final File imageFile;
  _DetailsScreenState(this.imageFile);

  Size _imageSize;
  String recognizedText = "Loading ...";
  List<TextElement> _elements = [];

  void _initializeVision() async {
    await _getImageSize();

    final FirebaseVisionImage visionImage =
        FirebaseVisionImage.fromFile(imageFile);
    final TextRecognizer textRecognizer =
        FirebaseVision.instance.textRecognizer();
    final VisionText visionText =
        await textRecognizer.processImage(visionImage);
    String blah = "";
    for (TextBlock block in visionText.blocks) {
      for (TextLine line in block.lines) {
        print(line.text);
        blah += line.text + "\n";
        for (TextElement element in line.elements) {
          _elements.add(element);
        }
      }
    }

    setState(() {
      recognizedText = blah;
    });
  }

  Future<void> _getImageSize() async {
    final Completer<Size> completer = Completer<Size>();
    // Fetching image from path
    final Image image = Image.file(imageFile);

    // Retrieving its size
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      }),
    );
    final Size imageSize = await completer.future;
    setState(() {
      _imageSize = imageSize;
    });
  }

  @override
  void initState() {
    _initializeVision();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Image Details"),
      // ),
      body: _imageSize != null
          ? Stack(
              children: <Widget>[
                Center(
                  child: Container(
                    width: double.maxFinite,
                    color: Colors.black,
                    child: CustomPaint(
                      foregroundPainter: TextDetectorPainter(
                        _imageSize,
                        _elements,
                      ),
                      child: AspectRatio(
                        aspectRatio: _imageSize.aspectRatio,
                        child: Image.file(
                          imageFile,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Card(
                    elevation: 8,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              "Identified text",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            height: 200,
                            child: SingleChildScrollView(
                              child: Text(
                                recognizedText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
    );
  }
}
