import 'package:career_counsellor/pages/resources/pages/quiz_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomQuizPage extends StatefulWidget {
  const CustomQuizPage({super.key});

  @override
  State<CustomQuizPage> createState() => _CustomQuizPageState();
}

class _CustomQuizPageState extends State<CustomQuizPage> {
  final _formKey = GlobalKey<FormState>();
  final _quizController = TextEditingController();

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
                          color: Colors.pink, // Set the border color to pink
                          width: 2.0, // Set the border width to 2
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
                          color: Colors
                              .red, // Optional: Set a red border for validation errors
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
                      hintText: 'Enter Quiz Topic', // Optional: Add a hint text
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
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) =>
                            QuizPage(title: _quizController.text)));
                  }
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        screenWidth * 0.02), // Make the button square
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
            ],
          ),
        ),
      ),
    );
  }
}
