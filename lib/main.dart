import 'package:flutter/material.dart';

import 'src/features/home/presentation/screens/image_selection.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CMS Distilled',
      debugShowCheckedModeBanner: false,
      home: GetImageScreen(),
    );
  }
}
