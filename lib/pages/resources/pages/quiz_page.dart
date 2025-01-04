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

    return Scaffold(
      body: Column(
        children: [
          Stack(
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
                  icon: Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
              CustomPaint(
                painter: SemiCirclePainter(),
                child: Container(),
              ),
            ],
          ),
        ],
      ),
    );
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
      Rect.fromCircle(center: Offset(radius-70, 180), radius: radius),
      -3.14 / 2,
      3.14,
      false,
      paint,
    );

    // Draw semi-circle on the right side
    canvas.drawArc(
      Rect.fromCircle(
          center: Offset(size.width, 240), radius: radius),
      3.14 / 2,
      3.14,
      false,
      paint,
    );

    // Draw circle in the middle
    canvas.drawCircle(
      Offset(size.width / 2-60, 30),
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
