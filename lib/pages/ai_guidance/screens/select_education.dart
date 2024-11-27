import 'package:career_counsellor/pages/ai_guidance/screens/career_survey_higher.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/career_survey_school.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectEducation extends StatelessWidget {
  const SelectEducation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Choose Your Current Education Level',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'School',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const CareerSurvey()),
                    );
                  },
                  icon: const Icon(CupertinoIcons.arrow_right),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Higher Education',
                  style: TextStyle(fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const CareerSurveyHigher()),
                    );
                  },
                  icon: const Icon(CupertinoIcons.arrow_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
