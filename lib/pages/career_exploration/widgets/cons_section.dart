import 'package:career_counsellor/pages/career_exploration/screens/elaborate_detail.dart';
import 'package:career_counsellor/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConsSection extends StatelessWidget {
  const ConsSection({
    super.key,
    required this.title,
    required this.content,
    required this.career,
    required this.type,
  });

  final String title;
  final List<String> content;
  final String career;
  final String type;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final isDarkTheme = themeData.brightness == Brightness.dark;
    const errorColor = AppColors.errorColor;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ElaborateDetail(
              title: title,
              career: career,
              type: type,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: errorColor.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDarkTheme
                ? errorColor.withValues(alpha: 0.3)
                : errorColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.warning_amber_outlined,
                    color: errorColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Challenges of Being a $career',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: errorColor,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 12),
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      errorColor.withValues(alpha: 0.1),
                      errorColor,
                      errorColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
              ...content.map((point) => Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isDarkTheme
                          ? errorColor.withValues(alpha: 0.1)
                          : errorColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: errorColor.withValues(alpha: 0.2),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          child: const Icon(
                            CupertinoIcons.exclamationmark_triangle_fill,
                            color: errorColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            point,
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.4,
                              color: isDarkTheme
                                  ? Colors.grey[300]
                                  : Colors.grey[800],
                            ),
                          ),
                        ),
                      ],
                    ),
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ElaborateDetail(
                          title: title,
                          career: career,
                          type: type,
                        ),
                      ),
                    );
                  },
                  icon: const Icon(
                    Icons.read_more,
                    size: 18,
                    color: errorColor,
                  ),
                  label: const Text('See all challenges'),
                  style: TextButton.styleFrom(
                    foregroundColor: errorColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
