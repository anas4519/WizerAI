import 'package:career_counsellor/auth/auth_gate.dart';
import 'package:career_counsellor/onboarding_screen/page_1.dart';
import 'package:career_counsellor/onboarding_screen/page_2.dart';
import 'package:career_counsellor/onboarding_screen/page_3.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  PageController _controller = PageController();
  bool onLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        PageView(
          onPageChanged: (index) {
            setState(() {
              onLastPage = index == 2;
            });
          },
          controller: _controller,
          children: const [
            Page1(),
            Page2(),
            Page3(),
          ],
        ),
        Positioned(
          bottom: 100,
          left: 24,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotWidth: 12,
                  dotHeight: 12,
                  activeDotColor: Colors.pink,
                  dotColor: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    _controller.jumpToPage(2);
                  },
                  child: const Text('Skip'))
            ],
          ),
        ),
        Positioned(
          bottom: 100,
          right: 24,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.lightImpact();
              if (onLastPage) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (ctx) => const AuthGate()));
              } else {
                _controller.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              }
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                color: Colors.pink,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[300],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
