import 'package:career_counsellor/pages/resources/pages/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class McqInstructionsPage extends StatelessWidget {
  const McqInstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Instructions for MCQ Quiz:',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Each question gives you 10 points. Try to score as high as possible!',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '2. You will have 30 seconds to answer each question.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '3. There are a total of 10 questions in this quiz.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '4. Each question will have 4 options. Choose the correct one carefully.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '5. Read each question thoroughly before selecting your answer.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '6. Once you submit an answer, it cannot be changed.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '7. Cheating is prohibited. This quiz is meant to test your knowledge fairly.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            const Text(
              '8. Try to answer all questions to the best of your ability to maximize your score.',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Good luck and enjoy the quiz!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (ctx) => QuizPage()));
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'Begin Quiz',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
