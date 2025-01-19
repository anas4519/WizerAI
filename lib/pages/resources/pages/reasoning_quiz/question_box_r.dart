import 'dart:async';
import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/quiz_page_r.dart';
import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/result_page_r.dart';
import 'package:flutter/material.dart';

class QuestionBoxR extends StatefulWidget {
  const QuestionBoxR({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.questions,
    required this.answers,
  });
  final String question;
  final int questionNumber;
  final List<String> questions;
  final List<String> answers;

  @override
  State<QuestionBoxR> createState() => _QuestionBoxStateR();
}

class _QuestionBoxStateR extends State<QuestionBoxR> {
  late int _remainingSeconds;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 120; // 1 minute countdown
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
        List<String> updatedAns = [...widget.answers, ''];
        if (widget.questionNumber == 10) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => ResultPageR(
                    questions: widget.questions,
                    answers: updatedAns,
                  )));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => QuizPageR(
                    questions: widget.questions,
                    currIdx: widget.questionNumber,
                    answers: updatedAns,
                  )));
        }
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.all(screenWidth * 0.04),
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.pink, width: 2),
          borderRadius: BorderRadius.circular(screenWidth * 0.04)),
      child: Column(
        children: [
          Container(
            width: screenWidth * 0.2,
            height: screenWidth * 0.2,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.pink,
            ),
            alignment: Alignment.center,
            child: Text(
              _formatTime(_remainingSeconds),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          SizedBox(
            height: screenHeight * 0.02,
          ),
          Text(
            'Question ${widget.questionNumber}/10',
            style: const TextStyle(
                color: Colors.pink, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(
            height: screenHeight * 0.04,
          ),
          Text(
            widget.question,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Colors.black, fontSize: 18),
          )
        ],
      ),
    );
  }
}
