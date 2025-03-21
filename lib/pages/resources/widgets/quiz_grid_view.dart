import 'package:career_counsellor/pages/resources/widgets/quiz_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class QuizGridView extends StatelessWidget {
  const QuizGridView({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final iconSize = size.width * 0.06;
    final padding = size.width * 0.03;

    return Container(
      padding: EdgeInsets.only(bottom: padding, left: padding, right: padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 0.85,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: skillOptions.length,
            itemBuilder: (context, index) {
              final skill = skillOptions[index];
              return QuizIcon(
                icon: Icon(
                  skill.icon,
                  size: iconSize,
                  color: skill.color,
                ),
                title: skill.title,
              );
            },
          ),
        ],
      ),
    );
  }
}

class SkillOption {
  final String title;
  final IconData icon;
  final Color color;

  SkillOption({required this.title, required this.icon, required this.color});
}

final List<SkillOption> skillOptions = [
  SkillOption(
    title: 'Communication',
    icon: CupertinoIcons.chat_bubble_2,
    color: Colors.blue,
  ),
  SkillOption(
    title: 'Problem Solving',
    icon: CupertinoIcons.question_circle,
    color: Colors.green,
  ),
  SkillOption(
    title: 'Teamwork',
    icon: Icons.group,
    color: Colors.orange,
  ),
  SkillOption(
    title: 'Adaptability',
    icon: CupertinoIcons.arrow_2_circlepath,
    color: Colors.purple,
  ),
  SkillOption(
    title: 'Leadership',
    icon: Icons.leaderboard,
    color: Colors.red,
  ),
  SkillOption(
    title: 'Time Management',
    icon: CupertinoIcons.time,
    color: Colors.teal,
  ),
  SkillOption(
    title: 'Attention to Detail',
    icon: CupertinoIcons.search,
    color: Colors.brown,
  ),
  SkillOption(
    title: 'Creativity',
    icon: CupertinoIcons.paintbrush,
    color: Colors.pink,
  ),
  SkillOption(
    title: 'Custom',
    icon: Icons.note_alt_rounded,
    color: Colors.cyan,
  ),
];
