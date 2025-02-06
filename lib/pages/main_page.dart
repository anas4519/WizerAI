import 'package:career_counsellor/pages/ai_guidance/ai_guidance.dart';
import 'package:career_counsellor/pages/career_exploration/career_exploration.dart';
import 'package:career_counsellor/pages/mentorship/mentorship_page.dart';
import 'package:career_counsellor/pages/resources/resource_portal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<Widget> pages = [];
  int _currIndex = 0;

  @override
  void initState() {
    super.initState();
    pages = [
      const AiGuidance(),
      const CareerExploration(),
      const ResourcePortal(),
      const MentorshipPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: IndexedStack(
        index: _currIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        color: isDarkTheme ? Colors.black : Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: GNav(
            onTabChange: (index) {
              setState(() {
                _currIndex = index;
              });
            },
            backgroundColor: isDarkTheme ? Colors.black : Colors.grey.shade200,
            color: isDarkTheme ? Colors.white : Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade900,
            gap: screenwidth * 0.02,
            padding: EdgeInsets.all(screenwidth * 0.04),
            tabs: const [
              GButton(
                icon: CupertinoIcons.home,
                text: 'Home',
              ),
              GButton(icon: CupertinoIcons.compass, text: 'Explore'),
              GButton(
                icon: CupertinoIcons.book_solid,
                text: 'Resources',
              ),
              GButton(
                icon: Icons.support_agent_rounded,
                text: 'Mentorship',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
