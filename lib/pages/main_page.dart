import 'package:career_counsellor/pages/ai_guidance/ai_guidance.dart';
import 'package:career_counsellor/pages/career_exploration/career_exploration.dart';
import 'package:career_counsellor/pages/mentorship/degree_exploration.dart';
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
      const DegreeExplorationPage()
    ];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkTheme = theme.brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currIndex,
        children: pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: GNav(
              onTabChange: (index) {
                setState(() {
                  _currIndex = index;
                });
              },
              backgroundColor: Colors.transparent,
              color: theme.colorScheme.onSurface.withOpacity(0.65),
              activeColor: isDarkTheme ? Colors.white : theme.primaryColor,
              tabBackgroundColor: theme.primaryColor.withOpacity(0.15),
              tabBorderRadius: 24,
              curve: Curves.easeOutExpo,
              duration: const Duration(milliseconds: 300),
              gap: 8,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              tabs: [
                GButton(
                  icon: CupertinoIcons.house_fill,
                  text: 'Home',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : theme.primaryColor,
                  ),
                ),
                GButton(
                  icon: CupertinoIcons.compass,
                  text: 'Explore',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : theme.primaryColor,
                  ),
                ),
                GButton(
                  icon: CupertinoIcons.book,
                  text: 'Resources',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : theme.primaryColor,
                  ),
                ),
                GButton(
                  icon: CupertinoIcons.doc_plaintext,
                  text: 'Degrees',
                  textStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDarkTheme ? Colors.white : theme.primaryColor,
                  ),
                ),
              ],
              selectedIndex: _currIndex,
              rippleColor: theme.primaryColor.withOpacity(0.2),
              hoverColor: theme.primaryColor.withOpacity(0.1),
            ),
          ),
        ),
      ),
    );
  }
}
