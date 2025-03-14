import 'dart:async';
import 'package:career_counsellor/models/question.dart';
import 'package:career_counsellor/pages/resources/pages/mcq_quiz/quiz_page_alt.dart';
import 'package:career_counsellor/pages/resources/pages/mcq_quiz/result_page.dart';
import 'package:flutter/material.dart';

class QuestionBox extends StatefulWidget {
  const QuestionBox({
    super.key,
    required this.question,
    required this.questionNumber,
    required this.questions,
    required this.currScore,
    required this.skipped,
    required this.wrongIndices,
  });

  final String question;
  final int questionNumber;
  final List<MCQ> questions;
  final int currScore;
  final int skipped;
  final List<int> wrongIndices;

  @override
  State<QuestionBox> createState() => _QuestionBoxState();
}

class _QuestionBoxState extends State<QuestionBox>
    with SingleTickerProviderStateMixin {
  late int _remainingSeconds;
  late Timer _timer;
  late AnimationController _animController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _remainingSeconds = 60;

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 60),
    );

    _progressAnimation =
        Tween<double>(begin: 1.0, end: 0.0).animate(_animController);
    _animController.forward();

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
        if (widget.questionNumber == 10) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => ResultPage(
                    currScore: widget.currScore,
                    skipped: widget.skipped + 1,
                    questions: widget.questions,
                    wrongIndices: widget.wrongIndices,
                  )));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (ctx) => QuizPageAlt(
                    questions: widget.questions,
                    currIdx: widget.questionNumber,
                    currScore: widget.currScore,
                    skipped: widget.skipped + 1,
                    wrongIndices: widget.wrongIndices,
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

  Color _getTimerColor() {
    if (_remainingSeconds > 30) {
      return Colors.green;
    } else if (_remainingSeconds > 10) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: screenWidth * 0.9,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDarkMode
              ? [Colors.pink.shade900, Colors.deepPurple.shade900]
              : [Colors.pink.shade100, Colors.pink.shade300],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
        boxShadow: [
          BoxShadow(
            color: Colors.pink.withOpacity(isDarkMode ? 0.3 : 0.4),
            blurRadius: 12,
            spreadRadius: 1,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(screenWidth * 0.06),
        child: Stack(
          children: [
            // Background design elements
            Positioned(
              top: -screenWidth * 0.15,
              right: -screenWidth * 0.15,
              child: Container(
                width: screenWidth * 0.3,
                height: screenWidth * 0.3,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              bottom: -screenWidth * 0.1,
              left: -screenWidth * 0.1,
              child: Container(
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(screenWidth * 0.06),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Timer circle with animation
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      // Outer circle
                      Container(
                        width: screenWidth * 0.22,
                        height: screenWidth * 0.22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDarkMode
                              ? Colors.black.withOpacity(0.3)
                              : Colors.white.withOpacity(0.3),
                        ),
                      ),

                      // Progress indicator
                      AnimatedBuilder(
                        animation: _progressAnimation,
                        builder: (context, child) {
                          return SizedBox(
                            width: screenWidth * 0.22,
                            height: screenWidth * 0.22,
                            child: CircularProgressIndicator(
                              value: _progressAnimation.value,
                              strokeWidth: 6,
                              backgroundColor: Colors.white.withOpacity(0.2),
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  _getTimerColor()),
                            ),
                          );
                        },
                      ),

                      // Timer text
                      Text(
                        _formatTime(_remainingSeconds),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.5),
                              blurRadius: 2,
                              offset: const Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                      vertical: screenWidth * 0.02,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                    ),
                    child: Text(
                      'Question ${widget.questionNumber}/10',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  Container(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? Colors.black.withOpacity(0.2)
                          : Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      widget.question,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 18,
                        height: 1.4,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.5),
                            blurRadius: 2,
                            offset: const Offset(1, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
