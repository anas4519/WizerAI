import 'dart:convert';

import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/quiz_page_r.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

class ReasoningInstructionsPage extends StatefulWidget {
  const ReasoningInstructionsPage({super.key, required this.title});
  final String title;

  @override
  State<ReasoningInstructionsPage> createState() =>
      _ReasoningInstructionsPageState();
}

class _ReasoningInstructionsPageState extends State<ReasoningInstructionsPage> {
  bool isLoading = false;
  List<String> questions = [];

  Future<void> createQuiz() async {
    HapticFeedback.lightImpact();
    setState(() {
      isLoading = true;
    });

    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );
    final prompt = '''
Create a Reasoning type quiz on the topic "${widget.title}" The user has two minutes to type the answer on their phone, there are 5 questions in total. Respond in the following JSON format:

{
  "questions": [
    {
      "question": "string",
    },
    ...
  ]
}
Ensure the JSON is properly formatted.
''';

    final content = [google_ai.Content.text(prompt)];
    try {
      final result = await model.generateContent(content);
      setState(() {
        if (result.text != null) {
          String text = result.text!.substring(7, result.text!.length - 4);
          Map<String, dynamic> map = jsonDecode(text);

          questions.clear();

          for (var questionData in map['questions']) {
            String question = questionData['question'];

            questions.add(question);
          }
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => QuizPageR(
                questions: questions, currIdx: 0, answers: const [])));

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        showSnackBar(context, 'Error: $e');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
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
                  onPressed: createQuiz,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 16),
                    child: isLoading
                        ? Row(
                            spacing: screenWidth * 0.05,
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Text(
                                'Creating Quiz',
                                style: TextStyle(fontSize: 18),
                              ),
                              CircularProgressIndicator()
                            ],
                          )
                        : const Text(
                            'Begin Quiz',
                            style: TextStyle(fontSize: 18),
                          ),
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              )
            ],
          ),
        ),
      ),
    );
  }
}
