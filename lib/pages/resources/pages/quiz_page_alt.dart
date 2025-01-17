import 'package:career_counsellor/models/question.dart';
import 'package:career_counsellor/pages/resources/pages/result_page.dart';
import 'package:career_counsellor/pages/resources/widgets/question_box.dart';
import 'package:flutter/material.dart';

class QuizPageAlt extends StatefulWidget {
  const QuizPageAlt(
      {super.key,
      required this.questions,
      required this.currIdx,
      required this.currScore,
      required this.skipped});
  final List<MCQ> questions;
  final int currIdx;
  final int currScore;
  final int skipped;

  @override
  State<QuizPageAlt> createState() => _QuizPageAltState();
}

class _QuizPageAltState extends State<QuizPageAlt> {
  int? selectedOption; // State variable to track the selected option

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.05,
            ),
            QuestionBox(
              questions: widget.questions,
              question: widget.questions[widget.currIdx].question,
              questionNumber: widget.currIdx + 1,
              currScore: widget.currScore,
              skipped: widget.skipped,
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 4, // Number of options
              itemBuilder: (context, index) {
                final isSelected = selectedOption == index;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        selectedOption = index;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth * 0.8, screenHeight * 0.07),
                      side: const BorderSide(color: Colors.pink),
                      backgroundColor: isSelected
                          ? Colors.pinkAccent
                          : (isDarkMode ? Colors.black : Colors.grey[200]),
                      foregroundColor: isSelected
                          ? Colors.white
                          : (isDarkMode ? Colors.white : Colors.black),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                      ),
                    ),
                    child: Text(index == 0
                        ? widget.questions[widget.currIdx].o1
                        : index == 1
                            ? widget.questions[widget.currIdx].o2
                            : index == 2
                                ? widget.questions[widget.currIdx].o3
                                : widget.questions[widget.currIdx].o4),
                  ),
                );
              },
            ),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            if (selectedOption != null)
              ElevatedButton(
                onPressed: () {
                  int score = selectedOption ==
                          widget.questions[widget.currIdx].correctIdx
                      ? 1
                      : 0;
                  if (widget.currIdx == 9) {
                    //result
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => ResultPage(
                              currScore: widget.currScore + score,
                              skipped: widget.skipped,
                            )));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => QuizPageAlt(
                              questions: widget.questions,
                              currIdx: widget.currIdx + 1,
                              currScore: widget.currScore + score,
                              skipped: widget.skipped,
                            )));
                  }
                },
                style: ElevatedButton.styleFrom(
                    minimumSize: Size(screenWidth * 0.6, screenHeight * 0.06),
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(screenWidth * 0.03))),
                child: const Text('Submit'),
              ),
          ],
        ),
      ),
    );
  }
}
