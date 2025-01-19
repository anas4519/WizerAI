import 'package:career_counsellor/pages/resources/pages/mcq_quiz/question_box.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        body: SingleChildScrollView(
      // Add ScrollView to prevent overflow
      child: SizedBox(
        // Specify a minimum height
        height: screenHeight,
        child: Column(
          children: [
            SizedBox(
              height: screenHeight * 0.5,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipPath(
                    clipper: CurvedClipper(),
                    child: Container(
                      height: screenHeight * 0.4,
                      color: Colors.pink,
                    ),
                  ),
                  Positioned(
                    top: 40,
                    left: 10,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  CustomPaint(
                    size: Size(screenWidth, screenHeight * 0.4),
                    painter: SemiCirclePainter(),
                  ),
                  // Positioned(
                  //   top: screenHeight * 0.3,
                  //   left: screenWidth * 0.1,
                  //   right: screenWidth * 0.1,
                  //   child: const QuestionBox(
                  //     question: 'Name the types of monkeys',
                  //     questionNumber: 1,
                  //   ),
                  // ),
                ],
              ),
            ),

            // Add your additional content here
            Padding(
              padding: const EdgeInsets.all(0),
              child: Column(
                children: [
                  // Example: Add answer options
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: 4, // Number of options
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Material(
                          elevation: 2,
                          borderRadius: BorderRadius.circular(10),
                          child: ListTile(
                            title: Text('Option ${index + 1}'),
                            onTap: () {
                              // Handle option selection
                            },
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 20),

                  // Example: Add a submit button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.pink,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 15,
                      ),
                    ),
                    onPressed: () {
                      // Handle submission
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double w = size.width;
    double h = size.height - 50;

    Path path = Path();
    path.lineTo(0, h);
    path.quadraticBezierTo(w * 0.5, h + 50, w, h);
    path.lineTo(w, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class SemiCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.pink.shade400
      ..style = PaintingStyle.fill;

    double radius = 70.0;

    // Draw semi-circle on the left edge
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius - 70, 180), radius: radius),
      -3.14 / 2,
      3.14,
      false,
      paint,
    );

    // Draw semi-circle on the right side
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width, 240), radius: radius),
      3.14 / 2,
      3.14,
      false,
      paint,
    );

    // Draw circle in the middle
    canvas.drawCircle(
      Offset(size.width / 2 - 60, 30),
      radius,
      paint,
    );

    canvas.drawCircle(
      Offset(size.width / 2 + 70, 60),
      30,
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
