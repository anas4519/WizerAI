import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/resources/pages/quiz_page_alt.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

class McqInstructionsPage extends StatefulWidget {
  const McqInstructionsPage({super.key});

  @override
  State<McqInstructionsPage> createState() => _McqInstructionsPageState();
}

class _McqInstructionsPageState extends State<McqInstructionsPage> {
  bool isLoading = false;

  Future<void> createQuiz() async {
    HapticFeedback.lightImpact();
    setState(() {
      isLoading = true;
    });

    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );
    final prompt =
        '''Create an mcq quiz with 4 options on the topic time management. The user has one minute to answer each question, there are 10 questions in total, also provide me with the answers and the explanation of the answer for each of the question. Respond in JSON Format.''';
    final content = [google_ai.Content.text(prompt)];
    try {
      final result = await model.generateContent(content);
      setState(() {
        if (result.text != null) {
          print(result.text);
        }
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
                          spacing: screenWidth * 0.02,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Creating Quiz'),
                            CircularProgressIndicator()
                          ],
                        )
                      : Text(
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
