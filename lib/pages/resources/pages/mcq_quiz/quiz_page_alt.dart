import 'package:career_counsellor/models/question.dart';
import 'package:career_counsellor/pages/resources/pages/mcq_quiz/result_page.dart';
import 'package:career_counsellor/pages/resources/pages/mcq_quiz/question_box.dart';
import 'package:flutter/material.dart';

class QuizPageAlt extends StatefulWidget {
  const QuizPageAlt({
    super.key,
    required this.questions,
    required this.currIdx,
    required this.currScore,
    required this.skipped,
    required this.wrongIndices,
  });
  final List<MCQ> questions;
  final int currIdx;
  final int currScore;
  final int skipped;
  final List<int> wrongIndices;

  @override
  State<QuizPageAlt> createState() => _QuizPageAltState();
}

class _QuizPageAltState extends State<QuizPageAlt>
    with SingleTickerProviderStateMixin {
  int? selectedOption;
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

    final optionGradient = LinearGradient(
      colors: isDarkMode
          ? [Colors.grey.shade900, Colors.grey.shade800]
          : [Colors.white, Colors.grey.shade100],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    final selectedGradient = LinearGradient(
      colors: [
        Colors.pink.shade400,
        Colors.pink.shade600,
      ],
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
                          'Score: ${widget.currScore}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          'Skipped: ${widget.skipped}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.03),

                  // Question box
                  QuestionBox(
                    questions: widget.questions,
                    question: widget.questions[widget.currIdx].question,
                    questionNumber: widget.currIdx + 1,
                    currScore: widget.currScore,
                    skipped: widget.skipped,
                    wrongIndices: widget.wrongIndices,
                  ),

                  SizedBox(height: screenHeight * 0.05),

                  // Options
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      final isSelected = selectedOption == index;
                      return Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: screenWidth * 0.04,
                        ),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient:
                                isSelected ? selectedGradient : optionGradient,
                            borderRadius:
                                BorderRadius.circular(screenWidth * 0.03),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: Colors.pink.withValues(alpha: 0.5),
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    )
                                  ]
                                : [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.1),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  selectedOption = index;
                                });
                              },
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.03),
                              splashColor: Colors.pink.withValues(alpha: 0.2),
                              highlightColor:
                                  Colors.pink.withValues(alpha: 0.1),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: screenHeight * 0.022,
                                  horizontal: screenWidth * 0.05,
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient:
                                            isSelected ? null : primaryGradient,
                                        color: isSelected ? Colors.white : null,
                                      ),
                                      child: Center(
                                        child: Text(
                                          String.fromCharCode(
                                              65 + index), // A, B, C, D
                                          style: TextStyle(
                                            color: isSelected
                                                ? Colors.pink
                                                : Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: screenWidth * 0.04),
                                    Expanded(
                                      child: Text(
                                        index == 0
                                            ? widget
                                                .questions[widget.currIdx].o1
                                            : index == 1
                                                ? widget
                                                    .questions[widget.currIdx]
                                                    .o2
                                                : index == 2
                                                    ? widget
                                                        .questions[
                                                            widget.currIdx]
                                                        .o3
                                                    : widget
                                                        .questions[
                                                            widget.currIdx]
                                                        .o4,
                                        style: TextStyle(
                                          color: isSelected
                                              ? Colors.white
                                              : (isDarkMode
                                                  ? Colors.white
                                                  : Colors.black87),
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.normal,
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
                    },
                  ),

                  SizedBox(height: screenHeight * 0.04),

                  // Submit button
                  if (selectedOption != null)
                    Container(
                      width: screenWidth * 0.7,
                      height: screenHeight * 0.07,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade400,
                            Colors.green.shade700
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(screenWidth * 0.05),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withValues(alpha: 0.4),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            int score = selectedOption ==
                                    widget.questions[widget.currIdx].correctIdx
                                ? 1
                                : 0;

                            List<int> updatedWrongIndices = score == 0
                                ? [...widget.wrongIndices, widget.currIdx]
                                : widget.wrongIndices;

                            if (widget.currIdx == 9) {
                              // Navigate to ResultPage
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) => ResultPage(
                                            currScore: widget.currScore + score,
                                            skipped: widget.skipped,
                                            questions: widget.questions,
                                            wrongIndices: updatedWrongIndices,
                                          )));
                            } else {
                              Navigator.of(context)
                                  .pushReplacement(MaterialPageRoute(
                                      builder: (ctx) => QuizPageAlt(
                                            questions: widget.questions,
                                            currIdx: widget.currIdx + 1,
                                            currScore: widget.currScore + score,
                                            skipped: widget.skipped,
                                            wrongIndices: updatedWrongIndices,
                                          )));
                            }
                          },
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.05),
                          splashColor: Colors.white.withValues(alpha: 0.2),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
