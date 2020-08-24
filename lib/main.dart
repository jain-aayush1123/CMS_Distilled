import 'package:flutter/material.dart';

import 'src/features/home/presentation/screens/image_selection.dart';
import 'src/utils/res/theme.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: THEME_DATA,
      title: 'CMS Distilled',
      debugShowCheckedModeBanner: false,
      home: GetImageScreen(),
    );
  }
}
