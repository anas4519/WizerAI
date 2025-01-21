import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/question_box_r.dart';
import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/result_page_r.dart';
import 'package:flutter/material.dart';

class QuizPageR extends StatefulWidget {
  const QuizPageR(
      {super.key,
      required this.questions,
      required this.currIdx,
      required this.answers});
  final List<String> questions;
  final int currIdx;
  final List<String> answers;

  @override
  State<QuizPageR> createState() => _QuizPageRState();
}

class _QuizPageRState extends State<QuizPageR> {
  final _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  
  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.05,
            ),
            QuestionBoxR(
              questions: widget.questions,
              question: widget.questions[widget.currIdx],
              questionNumber: widget.currIdx + 1,
              answers: widget.answers,
            ),
            SizedBox(
              height: screenHeight * 0.1,
            ),
            Form(
                key: _formKey,
                child: TextFormField(
                  maxLines: null,
                  controller: _answerController,
                  textCapitalization: TextCapitalization.sentences,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your answer.';
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
                    hintText: 'Start Typing...',
                  ),
                )),
            SizedBox(
              height: screenHeight * 0.02,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  List<String> updatedAns = [
                    ...widget.answers,
                    _answerController.text
                  ];
                  if (widget.currIdx == 4) {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => ResultPageR(
                              answers: updatedAns,
                              questions: widget.questions,
                            )));
                  } else {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (ctx) => QuizPageR(
                              questions: widget.questions,
                              currIdx: widget.currIdx + 1,
                              answers: updatedAns,
                            )));
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                  minimumSize: Size(screenWidth * 0.6, screenHeight * 0.06),
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.03))),
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
