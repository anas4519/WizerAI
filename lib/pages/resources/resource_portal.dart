import 'package:career_counsellor/pages/resources/widgets/quiz_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ResourcePortal extends StatelessWidget {
  const ResourcePortal({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.06; // fixed icon size for symmetry

    return Scaffold(
        appBar: AppBar(
          title: const Text('Resources'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Quizzes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // First Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuizIcon(
                        icon: Icon(
                          CupertinoIcons.chat_bubble_2,
                          size: iconSize,
                        ),
                        title: 'Communication Skills',
                      ),
                      QuizIcon(
                        icon: Icon(
                          CupertinoIcons.question_circle,
                          size: iconSize,
                        ),
                        title: 'Problem Solving',
                      ),
                      QuizIcon(
                        icon: Icon(
                          Icons.group,
                          size: iconSize,
                        ),
                        title: 'Teamwork',
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Second Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuizIcon(
                        icon: Icon(
                          Icons.autorenew,
                          size: iconSize,
                        ),
                        title: 'Flexibility',
                      ),
                      QuizIcon(
                        icon: Icon(
                          Icons.leaderboard,
                          size: iconSize,
                        ),
                        title: 'Leadership Skills',
                      ),
                      QuizIcon(
                        icon: Icon(
                          Icons.access_time,
                          size: iconSize,
                        ),
                        title: 'Time Management',
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // Third Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      QuizIcon(
                        icon: Icon(
                          Icons.search,
                          size: iconSize,
                        ),
                        title: 'Attention to Detail',
                      ),
                      QuizIcon(
                        icon: Icon(
                          Icons.brush_outlined,
                          size: iconSize,
                        ),
                        title: 'Creativity',
                      ),
                      QuizIcon(
                        icon: Icon(
                          Icons.note_alt_outlined,
                          size: iconSize,
                        ),
                        title: 'Custom',
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
