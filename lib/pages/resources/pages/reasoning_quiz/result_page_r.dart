import 'dart:convert';

import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/reasoning_question.dart';
import 'package:career_counsellor/pages/resources/widgets/results_container.dart';
import 'package:career_counsellor/pages/resources/widgets/score_circle.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:career_counsellor/widgets/info_container.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;
import 'package:lottie/lottie.dart';

class ResultPageR extends StatefulWidget {
  const ResultPageR(
      {super.key, required this.questions, required this.answers});
  final List<String> questions;
  final List<String> answers;

  @override
  State<ResultPageR> createState() => _ResultPageRState();
}

class _ResultPageRState extends State<ResultPageR> {
  bool isLoading = true;
  String body = '';
  int wrong = 0;
  int correct = 0;
  int totalScore = 0;
  List<ReasoningQuestion> answers = [];

  Future<void> _analyseAnswers() async {
    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );
    final prompt =
        ''' I need you to analyse, rate and provide feedback on these reasoning type quetions. The respective questions and answers have been provided below.
    You can give a maximum of 20 points each for each answer. If any answer is empty, you can give it zero. You can respond in first person if you want.
    Question 1 : ${widget.questions[0]}
    Answer 1 : ${widget.answers[0]}
    Question 2 : ${widget.questions[1]}
    Answer 2 : ${widget.answers[1]}
    Question 3 : ${widget.questions[2]}
    Answer 3 : ${widget.answers[2]}
    Question 4 : ${widget.questions[3]}
    Answer 4 : ${widget.answers[3]}
    Question 5 : ${widget.questions[4]}
    Answer 5 : ${widget.answers[4]}

    Respond in the following JSON Format :
    {
    "answers": [
    {
      "analysis": "string",
      "points": "int"
      "feedback": "string"
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
          body = result.text!;
          String text = result.text!.substring(7, result.text!.length - 4);
          Map<String, dynamic> map = jsonDecode(text);

          for (var answerData in map['answers']) {
            int pts = answerData['points'];
            totalScore += pts;
            if (pts < 10) {
              wrong++;
            } else {
              correct++;
            }

            answers.add(ReasoningQuestion(
                answerData['feedback'], answerData['analysis'], pts));
          }
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
  void initState() {
    _analyseAnswers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Results'),
          centerTitle: true,
          actions: [
            Padding(
              padding: EdgeInsets.all(screenWidth * 0.02),
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
        body: isLoading
            ? Center(
                child: Lottie.asset(
                  'assets/animations/ai-loader1.json',
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  fit: BoxFit.contain,
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(screenWidth * 0.04),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(child: ScoreCircle(currScore: totalScore / 10)),
                      SizedBox(height: screenHeight * 0.04),
                      ResultsContainer(
                          completion: 100,
                          total: widget.questions.length,
                          correct: correct,
                          wrong: wrong),
                      SizedBox(height: screenHeight * 0.04),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Detailed Analysis',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                      ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      for (var i = 0; i < answers.length; i++)
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: screenHeight * 0.01),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.circle,
                                color: answers[i].points < 10
                                    ? Colors.red[600]
                                    : Colors.green,
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Q${i + 1}. ${widget.questions[i]}',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),

                                    // Display the correct answer
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Answer Analysis:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(answers[i].analysis)
                                      ],
                                    ),
                                    SizedBox(height: screenHeight * 0.005),

                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Feedback:',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(answers[i].feedback)
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      SizedBox(
                        height: screenHeight * 0.02,
                      ),
                      const InfoContainer(
                          text:
                              'This content is generated by AI and may sometimes contain inaccuracies or incomplete information. Please verify independently when necessary.')
                    ]),
              ));
  }
}
