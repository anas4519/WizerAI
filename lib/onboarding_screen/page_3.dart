import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 64,
              ),
              const Text(
                'Resources & Skill Assessments',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Access expert resources and test your skills with AI-powered quizzes.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 128),
              Center(
                child: SvgPicture.asset(
                  'assets/onboarding_images/image_3.svg',
                  fit: BoxFit.contain,
                  width: screenWidth * 0.8,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
