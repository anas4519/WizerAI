import 'package:career_counsellor/pages/ai_guidance/screens/career_survey_higher.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/career_survey_school.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectEducation extends StatelessWidget {
  const SelectEducation({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Please select your current level of education from the options below:',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: screenHeight * 0.04),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const CareerSurvey()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.4, screenWidth * 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.school,
                    size: 50,
                    color: Colors.blue,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  const Text('School',
                      style: TextStyle(fontSize: 20, color: Colors.blue)),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => const CareerSurveyHigher()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.4, screenWidth * 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
              ),
              child: Column(
                children: [
                  const Icon(Icons.military_tech,
                      size: 50, color: Colors.green),
                  SizedBox(height: screenHeight * 0.01),
                  const Text('Graduation',
                      style: TextStyle(fontSize: 20, color: Colors.green)),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (ctx) => const CareerSurveyHigher()),
                );
              },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(screenWidth * 0.4, screenWidth * 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.04),
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    CupertinoIcons.book,
                    size: 50,
                    color: Colors.purple,
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  const Text('Post-Graduation',
                      style: TextStyle(fontSize: 14, color: Colors.purple)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
