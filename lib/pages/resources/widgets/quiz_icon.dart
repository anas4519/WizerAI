import 'package:career_counsellor/pages/resources/pages/custom_quiz_page.dart';
import 'package:career_counsellor/pages/resources/pages/quiz_selection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuizIcon extends StatelessWidget {
  const QuizIcon({super.key, required this.title, required this.icon});
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
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
                builder: (context) => QuizSelection(title: title),
              ),
            );
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: icon.color?.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: icon,
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 10,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
