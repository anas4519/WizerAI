import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class MentorshipPage extends StatelessWidget {
  const MentorshipPage({super.key});

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
                'assets/graphics/undraw_remote-meeting_l9wx.svg',
                width: screenWidth * 0.8,
              ),
              const Text(
                'Unfortunately, we don\'t have any counsellors yet.\n\nIf you are interested to sign up as a counsellor, send your resume at :\nxyz@gmail.com',
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
