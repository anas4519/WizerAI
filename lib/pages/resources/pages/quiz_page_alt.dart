import 'package:career_counsellor/pages/resources/widgets/question_box.dart';
import 'package:flutter/material.dart';

class QuizPageAlt extends StatefulWidget {
  const QuizPageAlt(
      {super.key, required this.questions, required this.currIdx});
  final List<String> questions;
  final int currIdx;

  @override
  State<QuizPageAlt> createState() => _QuizPageAltState();
}

class _QuizPageAltState extends State<QuizPageAlt> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            QuestionBox(
                question: widget.questions[widget.currIdx],
                questionNumber: widget.currIdx + 1),
            SizedBox(
              height: screenHeight * 0.15,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4, // Number of options
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(10),
                    child: ListTile(
                      title: Text('Option ${index + 1}'),
                      onTap: () {
                        // Handle option selection
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
