import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

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
                'AI-Powered Career Guidance',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Get personalized career recommendations based on your strengths and interests.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(
                height: 200,
              ),
              Center(
                child: SvgPicture.asset(
                  'assets/onboarding_images/image_1.svg',
                  width: screenWidth * 0.8,
                  fit: BoxFit.contain,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
