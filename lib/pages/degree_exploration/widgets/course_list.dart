import 'package:career_counsellor/pages/degree_exploration/utils/lists.dart';
import 'package:career_counsellor/pages/degree_exploration/widgets/degree_tile.dart';
import 'package:flutter/material.dart';

class CourseList extends StatelessWidget {
  final int idx;
  final bool isBachelorsSelected;
  const CourseList(
      {super.key, required this.idx, required this.isBachelorsSelected});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: ListView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: isBachelorsSelected
            ? mainList[idx][0].length
            : mainList[idx][1].length,
        itemBuilder: (context, index) {
          final courseName = isBachelorsSelected
              ? mainList[idx][0][index]
              : mainList[idx][1][index];

          return DegreeTile(
              isDarkMode: isDarkMode, index: index, courseName: courseName);
        },
      ),
    );
  }
}
