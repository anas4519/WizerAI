import 'package:career_counsellor/pages/resources/widgets/quiz_icon.dart';
import 'package:flutter/material.dart';

class ResourcePortal extends StatelessWidget {
  const ResourcePortal({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
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
                'Quizes',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: screenHeight * 0.02),
              Column(
                spacing: screenHeight * 0.02,
                children: const [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      QuizIcon(
                        icon: Icon(Icons.sports_soccer),
                        title: 'Soccer',
                      ),
                      QuizIcon(
                        icon: Icon(Icons.sports_football),
                        title: 'Football',
                      ),
                      QuizIcon(
                        icon: Icon(Icons.sports_cricket),
                        title: 'Cricket',
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      QuizIcon(
                        icon: Icon(Icons.note_alt_outlined),
                        title: 'Custom',
                      ),
                      QuizIcon(
                        icon: Icon(Icons.sports_football),
                        title: 'Football',
                      ),
                      QuizIcon(
                        icon: Icon(Icons.sports_football),
                        title: 'Football',
                      ),
                    ],
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      QuizIcon(
                        icon: Icon(Icons.sports_football),
                        title: 'Football',
                      ),
                      QuizIcon(
                        icon: Icon(Icons.sports_football),
                        title: 'Football',
                      ),
                      QuizIcon(
                        icon: Icon(Icons.sports_football),
                        title: 'Football',
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
