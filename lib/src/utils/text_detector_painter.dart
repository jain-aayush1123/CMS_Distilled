import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';

class TextDetectorPainter extends CustomPainter {
  TextDetectorPainter(this.absoluteImageSize, this.elements);

  final Size absoluteImageSize;
  final List<TextElement> elements;

  @override
  void paint(Canvas canvas, Size size) {
    // TODO: Define painter
  }

  @override
  bool shouldRepaint(TextDetectorPainter oldDelegate) {
    return true;
  }
}
