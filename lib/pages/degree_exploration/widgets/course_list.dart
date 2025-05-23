import 'package:career_counsellor/pages/degree_exploration/utils/lists.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

          return AnimatedContainer(
            duration: Duration(milliseconds: 200 + (index * 50)),
            margin: const EdgeInsets.only(bottom: 12),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  // Handle course selection with haptic feedback
                  HapticFeedback.selectionClick();
                },
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[900] : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDarkMode
                          ? Colors.grey[700]!.withOpacity(0.5)
                          : Colors.grey[200]!,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isDarkMode
                            ? Colors.black.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.05),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          courseName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: isDarkMode ? Colors.white : Colors.black87,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.pink.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
