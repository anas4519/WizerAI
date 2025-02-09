import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Page2 extends StatelessWidget {
  const Page2({super.key});

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
                'Explore Career Paths with Ease',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(
                height: 12,
              ),
              const Text(
                'Discover industries, roles, and opportunities that align with your goals.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 128),
              Center(
                child: SvgPicture.asset(
                  'assets/onboarding_images/image_2.svg',
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
