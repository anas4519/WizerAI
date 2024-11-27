import 'package:career_counsellor/pages/ai_guidance/screens/select_education.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AiGuidance extends StatelessWidget {
  const AiGuidance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Hello Champ!',
              style: TextStyle(fontSize: 20),
            ),
            const Text('Ready to take the survey?'),
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const SelectEducation()));
                },
                icon: const Icon(CupertinoIcons.arrow_right))
          ],
        ),
      ),
    );
  }
}
