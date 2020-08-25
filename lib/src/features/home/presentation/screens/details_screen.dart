import 'dart:async';
import 'dart:io';

import 'package:clay_containers/clay_containers.dart';
import 'package:cms_distilled/src/utils/res/colors.dart';
import 'package:cms_distilled/src/utils/text_detector_painter.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  String recognizedText = "Magic is happening...";
  List<TextElement> _elements = [];
  TextEditingController _controller;

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
        // print(line.text);
        if (!line.text.contains("Le") &&
            !line.text.contains("ure") &&
            !line.text.contains("Tut") &&
            !line.text.contains("Practical") &&
            !line.text.contains("Laboratory") &&
            !line.text.contains("Location") &&
            !line.text.contains("TBA") &&
            !line.text.contains("AM") &&
            !line.text.contains("PM") &&
            !line.text.contains("Aug")) {
          blah += line.text + "\n";
          for (TextElement element in line.elements) {
            _elements.add(element);
          }
        }
      }
    }

    setState(() {
      recognizedText = blah;
      _controller = TextEditingController(text: recognizedText);
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
    _controller = TextEditingController(text: recognizedText);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(24.0),
      topRight: Radius.circular(24.0),
    );
    return DetailsScreenUI(
      radius: radius,
      controller: _controller,
      width: width,
      imageSize: _imageSize,
      elements: _elements,
      imageFile: imageFile,
    );
  }
}

class DetailsScreenUI extends StatelessWidget {
  const DetailsScreenUI({
    Key key,
    @required this.radius,
    @required TextEditingController controller,
    @required this.width,
    @required Size imageSize,
    @required List<TextElement> elements,
    @required this.imageFile,
  })  : _controller = controller,
        _imageSize = imageSize,
        _elements = elements,
        super(key: key);

  final BorderRadiusGeometry radius;
  final TextEditingController _controller;
  final double width;
  final Size _imageSize;
  final List<TextElement> _elements;
  final File imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SlidingUpPanel(
        defaultPanelState: PanelState.OPEN,
        borderRadius: radius,
        panel: Container(
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: radius,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(
                      Icons.drag_handle,
                      color: uiColor,
                    ),
                    // SizedBox(height: 5),
                    Text(
                      "Identified Subjects",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ClayContainer(
                  color: baseColor,
                  emboss: true,
                  child: TextField(
                    controller: _controller,
                    maxLines: 14,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: ClayContainer(
                        color: baseColor,
                        height: 50,
                        width: width * 0.4,
                        borderRadius: 100,
                        curveType: CurveType.concave,
                        child: Center(
                          child: ClayText(
                            "RETAKE",
                            emboss: true,
                            textColor: uiColor,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              // color: primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ClayContainer(
                      color: baseColor,
                      height: 50,
                      width: width * 0.4,
                      borderRadius: 100,
                      curveType: CurveType.convex,
                      child: Center(
                        child: ClayText(
                          "ENROLL",
                          // emboss: true,
                          textColor: primaryColor,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            // color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: Center(
          child: _imageSize != null
              ? Container(
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
                )
              : CircularProgressIndicator(),
        ),
      ),
    );
  }
}
