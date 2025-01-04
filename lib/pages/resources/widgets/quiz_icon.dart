import 'package:career_counsellor/pages/resources/pages/custom_quiz_page.dart';
import 'package:career_counsellor/pages/resources/pages/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizIcon extends StatelessWidget {
  const QuizIcon({super.key, required this.title, required this.icon});
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: MediaQuery.of(context).size.width * 0.01,
        children: [
          ElevatedButton(
            onPressed: () {
              HapticFeedback.lightImpact();
              if (title == 'Custom') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CustomQuizPage(),
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuizPage(title: title),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: icon,
            ),
          ),
          Text(
            title,
            style: TextStyle(fontSize: screenWidth * 0.02),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
