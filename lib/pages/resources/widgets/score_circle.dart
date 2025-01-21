import 'package:flutter/material.dart';

class ScoreCircle extends StatelessWidget {
  const ScoreCircle({super.key, required this.currScore});
  final double currScore;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      width: screenWidth * 0.575,
      height: screenWidth * 0.575,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).brightness == Brightness.light
        ? Colors.black.withOpacity(0.7) // Outer circle color for light mode
        : Colors.white.withOpacity(0.7), // Outer circle color for dark mode
      ),
      child: Center(
        child: Container(
          width: screenWidth * 0.45,
          height: screenWidth * 0.45,
          decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.black.withOpacity(0.5) // Middle circle color for light mode
            : Colors.white.withOpacity(0.5), // Middle circle color for dark mode
          ),
          child: Center(
        child: Container(
          width: screenWidth * 0.35,
          height: screenWidth * 0.35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Theme.of(context).brightness == Brightness.light
            ? Colors.black // Inner circle color for light mode
            : Colors.white, // Inner circle color for dark mode
          ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Your Score', // Replace with your text
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${currScore.toInt() * 10}/100', // Replace with your text
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
