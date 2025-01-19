import 'package:career_counsellor/models/question.dart';
import 'package:career_counsellor/pages/resources/widgets/results_container.dart';
import 'package:career_counsellor/pages/resources/widgets/score_circle.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({
    super.key,
    required this.currScore,
    required this.skipped,
    required this.questions,
    required this.wrongIndices,
  });

  final int currScore;
  final int skipped;
  final List<MCQ> questions;
  final List<int> wrongIndices;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  bool isWrongAnswersExpanded = false;
  bool isRightAnswersExpanded = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Results',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(child: ScoreCircle(currScore: widget.currScore)),
            SizedBox(height: screenHeight * 0.04),
            ResultsContainer(
              completion: 100 - (10 * widget.skipped),
              total: widget.questions.length,
              correct: widget.currScore,
              wrong:
                  widget.questions.length - widget.currScore - widget.skipped,
            ),
            SizedBox(height: screenHeight * 0.04),

            // Wrong answers section
            InkWell(
              onTap: () {
                setState(() {
                  isWrongAnswersExpanded = !isWrongAnswersExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wrong Answers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    isWrongAnswersExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 28,
                  ),
                ],
              ),
            ),
            if (isWrongAnswersExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    for (int index in widget.wrongIndices)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.circle, color: Colors.red[600]),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Q${index + 1}. ${widget.questions[index].question}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),

                                  // Display the correct answer
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Correct Answer:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.questions[index].correctIdx == 0
                                            ? widget.questions[index].o1
                                            : widget.questions[index]
                                                        .correctIdx ==
                                                    1
                                                ? widget.questions[index].o2
                                                : widget.questions[index]
                                                            .correctIdx ==
                                                        2
                                                    ? widget.questions[index].o3
                                                    : widget
                                                        .questions[index].o4,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.005),

                                  // Display the explanation
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Explanation:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.questions[index].explanation,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            SizedBox(height: screenHeight * 0.04),

            // Right answers section
            InkWell(
              onTap: () {
                setState(() {
                  isRightAnswersExpanded = !isRightAnswersExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Right Answers',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    isRightAnswersExpanded
                        ? Icons.arrow_drop_up
                        : Icons.arrow_drop_down,
                    size: 28,
                  ),
                ],
              ),
            ),
            if (isRightAnswersExpanded)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    for (var i = 0; i < widget.questions.length; i++)
                      Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.circle, color: Colors.yellow),
                            SizedBox(width: screenWidth * 0.02),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Q${i + 1}. ${widget.questions[i].question}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),

                                  // Display the correct answer
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Correct Answer:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.questions[i].correctIdx == 0
                                            ? widget.questions[i].o1
                                            : widget.questions[i].correctIdx ==
                                                    1
                                                ? widget.questions[i].o2
                                                : widget.questions[i]
                                                            .correctIdx ==
                                                        2
                                                    ? widget.questions[i].o3
                                                    : widget.questions[i].o4,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Explanation:',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        widget.questions[i].explanation,
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                  ],
                ),
              ),
            SizedBox(
              height: screenHeight * 0.01,
            )
          ],
        ),
      ),
    );
  }
}
