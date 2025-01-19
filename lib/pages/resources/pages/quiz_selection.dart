import 'package:career_counsellor/pages/resources/pages/mcq_quiz/mcq_instructions.dart';
import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/reasoning_instructions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizSelection extends StatelessWidget {
  const QuizSelection({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Quiz Type'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.04,
            ),
            Text(
              'Please select what kind of quiz would you like to take:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.125),
            SizedBox(
              width: screenWidth * 0.4,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => McqInstructionsPage(
                        title: title,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.4, screenWidth * 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      CupertinoIcons.check_mark_circled,
                      size: 50,
                      color: Colors.blue,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    const Text('Multiple Choice',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.blue)),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            SizedBox(
              width: screenWidth * 0.4,
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.mediumImpact();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReasoningInstructionsPage(title: title,),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.4, screenWidth * 0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.04),
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.subject, size: 50, color: Colors.green),
                    SizedBox(height: screenHeight * 0.01),
                    const Text('Reasoning Type',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, color: Colors.green)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
