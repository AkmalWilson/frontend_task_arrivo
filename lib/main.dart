import 'package:flutter/material.dart';
import 'screens/post_table_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Posts Table',
      home: PostTableScreen(),
    );
  }
}
