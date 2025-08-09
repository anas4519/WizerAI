import 'package:flutter/material.dart';

class CourseDetail extends StatelessWidget {
  final String title;
  const CourseDetail({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text('Content is here'),
      ),
    );
  }
}
