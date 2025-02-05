import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: screenHeight * 0.04,
            children: [
              SvgPicture.asset(
                'assets/graphics/no_courses_image.svg',
                width: screenWidth * 0.8,
              ),
              const Text(
                'Unfortunately, we don\'t have any courses yet.',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
