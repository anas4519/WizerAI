import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/question_box_r.dart';
import 'package:career_counsellor/pages/resources/pages/reasoning_quiz/result_page_r.dart';
import 'package:flutter/material.dart';

class QuizPageR extends StatefulWidget {
  const QuizPageR({
    super.key,
    required this.questions,
    required this.currIdx,
    required this.answers,
  });
  final List<String> questions;
  final int currIdx;
  final List<String> answers;

  @override
  State<QuizPageR> createState() => _QuizPageRState();
}

class _QuizPageRState extends State<QuizPageR>
    with SingleTickerProviderStateMixin {
  final _answerController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _answerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Define gradient colors based on theme
    final primaryGradient = LinearGradient(
      colors: [
        Colors.pink.shade300,
        Colors.pink.shade500,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final inputGradient = LinearGradient(
      colors: isDarkMode
          ? [Colors.grey.shade900, Colors.grey.shade800]
          : [Colors.white, Colors.grey.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.grey.shade900, Colors.black]
                : [Colors.grey.shade50, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _animation,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: screenHeight * 0.02),

                  // Quiz progress indicators
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Row(
                      children: [
                        Text(
                          'Question ${widget.currIdx + 1}/${widget.questions.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Answered: ${widget.answers.length}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Progress bar
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    child: Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? Colors.grey.shade800
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: screenWidth *
                              0.92 *
                              ((widget.currIdx + 1) / widget.questions.length),
                          height: 8,
                          decoration: BoxDecoration(
                            gradient: primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Question box
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenWidth * 0.04),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: QuestionBoxR(
                      questions: widget.questions,
                      question: widget.questions[widget.currIdx],
                      questionNumber: widget.currIdx + 1,
                      answers: widget.answers,
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Answer input
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                    decoration: BoxDecoration(
                      gradient: inputGradient,
                      borderRadius: BorderRadius.circular(screenWidth * 0.03),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(screenWidth * 0.04),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: primaryGradient,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.edit_outlined,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: screenWidth * 0.03),
                                Text(
                                  'Your Answer',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: screenHeight * 0.02),
                            TextFormField(
                              maxLines: null,
                              minLines: 4,
                              controller: _answerController,
                              textCapitalization: TextCapitalization.sentences,
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
                                height: 1.5,
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your answer.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                contentPadding:
                                    EdgeInsets.all(screenWidth * 0.04),
                                filled: true,
                                fillColor: isDarkMode
                                    ? Colors.grey.shade800
                                    : Colors.white,
                                hintText: 'Start typing your answer here...',
                                hintStyle: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey.shade400
                                      : Colors.grey.shade400,
                                  fontStyle: FontStyle.italic,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                  borderSide: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey.shade700
                                        : Colors.pink.shade200,
                                    width: 1.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                  borderSide: BorderSide(
                                    color: isDarkMode
                                        ? Colors.grey.shade700
                                        : Colors.pink.shade200,
                                    width: 1.0,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                  borderSide: BorderSide(
                                    color: Colors.pink.shade500,
                                    width: 2.0,
                                  ),
                                ),
                                errorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                  borderSide: BorderSide(
                                    color: Colors.red.shade300,
                                    width: 1.0,
                                  ),
                                ),
                                focusedErrorBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                  borderSide: const BorderSide(
                                    color: Colors.red,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Submit button
                  Container(
                    width: screenWidth * 0.7,
                    height: screenHeight * 0.07,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade400, Colors.green.shade700],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(screenWidth * 0.05),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withOpacity(0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            List<String> updatedAns = [
                              ...widget.answers,
                              _answerController.text
                            ];
                            if (widget.currIdx == 4) {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) => ResultPageR(
                                            answers: updatedAns,
                                            questions: widget.questions,
                                          )));
                            } else {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) => QuizPageR(
                                            questions: widget.questions,
                                            currIdx: widget.currIdx + 1,
                                            answers: updatedAns,
                                          )));
                            }
                          }
                        },
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        splashColor: Colors.white.withOpacity(0.2),
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Submit',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(width: screenWidth * 0.02),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Skip button
                  TextButton(
                    onPressed: widget.currIdx < 4
                        ? () {
                            List<String> updatedAns = [
                              ...widget.answers,
                              "Skipped"
                            ];
                            Navigator.of(context)
                                .pushReplacement(MaterialPageRoute(
                                    builder: (ctx) => QuizPageR(
                                          questions: widget.questions,
                                          currIdx: widget.currIdx + 1,
                                          answers: updatedAns,
                                        )));
                          }
                        : null,
                    child: Text(
                      'Skip this question',
                      style: TextStyle(
                        color: widget.currIdx < 4
                            ? Colors.pink.shade400
                            : Colors.grey,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
