import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Color testColor = Colors.red;

  @override
  Widget build(BuildContext context) {
    int testColorValue = testColor.value;
  print(testColorValue);
    return Container(height: 50, width: 50, color: Color(testColorValue));
  }
}
