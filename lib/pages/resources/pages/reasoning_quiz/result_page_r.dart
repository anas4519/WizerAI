import 'package:flutter/material.dart';

class ResultPageR extends StatefulWidget {
  const ResultPageR(
      {super.key, required this.questions, required this.answers});
  final List<String> questions;
  final List<String> answers;

  @override
  State<ResultPageR> createState() => _ResultPageRState();
}

class _ResultPageRState extends State<ResultPageR> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
