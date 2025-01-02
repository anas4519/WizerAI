import 'package:flutter/material.dart';

class QuizIcon extends StatelessWidget {
  const QuizIcon({super.key, required this.title, required this.icon});
  final String title;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: MediaQuery.of(context).size.width * 0.01,
      children: [
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: icon,
          ),
        ),
        Text(title, style: Theme.of(context).textTheme.titleSmall),
      ],
    );
  }
}
