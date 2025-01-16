import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  const ResultPage({super.key, required this.currScore});
  final int currScore;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('$currScore/10'),
      ),
    );
  }
}