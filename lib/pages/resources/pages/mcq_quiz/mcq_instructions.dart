import 'dart:convert';

import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/question.dart';
import 'package:career_counsellor/pages/resources/pages/mcq_quiz/quiz_page_alt.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

class McqInstructionsPage extends StatefulWidget {
  const McqInstructionsPage({super.key, required this.title});
  final String title;

  @override
  State<McqInstructionsPage> createState() => _McqInstructionsPageState();
}

class _McqInstructionsPageState extends State<McqInstructionsPage> {
  bool isLoading = false;
  List<MCQ> questions = [];

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
Create an MCQ quiz with 4 options on the topic "${widget.title}" The user has one minute to answer each question, there are 10 questions in total. Also provide the answers and the explanation of the answer for each question. Respond in the following JSON format:

{
  "questions": [
    {
      "question": "string",
      "options": ["string", "string", "string", "string"],
      "correct_option_index": integer (0-based),
      "explanation": "string"
    },
    ...
  ]
}
Ensure the JSON is properly formatted and all fields are provided for each question.
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
            List<String> options = List<String>.from(questionData['options']);
            int correctIdx = questionData['correct_option_index'];
            String exp = questionData['explanation'];

            questions.add(MCQ(
              question: question,
              o1: options[0],
              o2: options[1],
              o3: options[2],
              o4: options[3],
              explanation: exp,
              correctIdx: correctIdx,
            ));
          }
        }
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => QuizPageAlt(
                  questions: questions,
                  currIdx: 0,
                  currScore: 0,
                  skipped: 0,
                  wrongIndices: const [],
                )));

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
                onPressed: createQuiz,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
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
          ],
        ),
      ),
    );
  }
}
