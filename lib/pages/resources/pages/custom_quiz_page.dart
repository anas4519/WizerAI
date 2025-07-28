import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/resources/pages/quiz_selection.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;
import 'package:lottie/lottie.dart';

class CustomQuizPage extends StatefulWidget {
  const CustomQuizPage({super.key});

  @override
  State<CustomQuizPage> createState() => _CustomQuizPageState();
}

class _CustomQuizPageState extends State<CustomQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _quizController = TextEditingController();
  bool isLoading = false;

  Future<void> _checkValidity() async {
    final model = genai.GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );
    final prompt =
        '''Respond in only yes/no: Is ${_quizController.text} a valid topic for a quiz that you could generate?''';
    final content = [genai.Content.text(prompt)];
    try {
      final result = await model.generateContent(content);
      if (result.text != null) {
        if (result.text!.toLowerCase().contains('yes') && mounted) {
          isLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizSelection(title: _quizController.text),
            ),
          );
        } else {
          setState(() {
            showSnackBar(context, 'Please enter a valid quiz topic.');
            isLoading = false;
          });
        }
      }
    } catch (e) {
      setState(() {
        showSnackBar(context, 'Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Topic'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: screenHeight * 0.04,
              ),
              Text(
                'Please enter the topic for the quiz you wish to take:',
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenHeight * 0.125),
              Form(
                  key: _formKey,
                  child: TextFormField(
                    maxLines: null,
                    controller: _quizController,
                    textCapitalization: TextCapitalization.sentences,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the quiz topic.';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(
                          color: Colors.pink,
                          width: 2.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(
                          color: Colors.pink,
                          width: 2.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(
                          color: Colors.pink,
                          width: 2.0,
                        ),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        borderSide: const BorderSide(
                          color: Colors.red,
                          width: 2.0,
                        ),
                      ),
                      hintText: 'Enter Quiz Topic',
                    ),
                  )),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              ElevatedButton(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  HapticFeedback.lightImpact();
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    _checkValidity();
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.02,
                      horizontal: screenWidth * 0.05),
                  child: const Text(
                    'Generate Quiz',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.05,
              ),
              if (isLoading)
                Lottie.asset(
                  'assets/animations/ai-loader1.json',
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  fit: BoxFit.contain,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
