import 'package:career_counsellor/pages/resources/widgets/results_container.dart';
import 'package:career_counsellor/pages/resources/widgets/score_circle.dart';
import 'package:flutter/material.dart';

class ResultPage extends StatefulWidget {
  const ResultPage({super.key, required this.currScore, required this.skipped});
  final int currScore;
  final int skipped;

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  // State variables to manage the visibility of text
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
              completion: 100 - (10*widget.skipped),
              total: 10,
              correct: widget.currScore,
              wrong: 10-widget.currScore-widget.skipped,
            ),
            SizedBox(height: screenHeight * 0.04),

            // First InkWell for wrong answers
            InkWell(
              onTap: () {
                setState(() {
                  isWrongAnswersExpanded = !isWrongAnswersExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Wrong answers',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text(
                  'Here are the detailed wrong answers...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
            SizedBox(height: screenHeight * 0.04),

            // Second InkWell for right answers
            InkWell(
              onTap: () {
                setState(() {
                  isRightAnswersExpanded = !isRightAnswersExpanded;
                });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Right answers',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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
                child: Text(
                  'Here are the detailed correct answers...',
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
