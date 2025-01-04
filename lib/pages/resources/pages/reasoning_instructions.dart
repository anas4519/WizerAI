import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ReasoningInstructionsPage extends StatelessWidget {
  const ReasoningInstructionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Instructions for Reasoning Quiz:',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text(
                '1. Each question tests how well you can handle a particular situation.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '2. You will have 2 minutes to answer each question.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '3. There are a total of 10 questions in this quiz.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '4. Questions may involve patterns, sequences, puzzles, or analytical scenarios.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '5. Read each question carefully before attempting to solve it.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '6. You will have an input field to type your answer in.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '7. Once you submit an answer, it cannot be changed.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '8. Try to answer all questions to the best of your ability to maximize your score.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tips for Success:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Look for patterns or relationships in the questions.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Manage your time efficiently and avoid spending too much time on a single question.',
                style: TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 16),
              const Text(
                'Good luck and stay focused!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
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
      ),
    );
  }
}
