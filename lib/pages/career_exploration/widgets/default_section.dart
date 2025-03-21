import 'package:career_counsellor/pages/career_exploration/screens/elaborate_detail.dart';
import 'package:career_counsellor/utils/app_colors.dart';
import 'package:flutter/material.dart';

class DefaultSection extends StatelessWidget {
  const DefaultSection({
    Key? key,
    required this.title,
    required this.content,
    required this.career,
  }) : super(key: key);

  final String title;
  final List<String> content;
  final String career;

  Color _getSectionColor() {
    switch (title) {
      case 'Overview':
        return Colors.pink;
      case 'Education Required in India':
        return AppColors.educationColor;
      case 'Best Schools in India':
        return Colors.blue;
      case 'Work Environment':
        return Colors.orange;
      case 'Salaries in India':
        return AppColors.salaryColor;
      case 'Industry Trends':
        return AppColors.trendColor;
      default:
        return AppColors.primaryColor;
    }
  }

  IconData _getSectionIcon() {
    switch (title) {
      case 'Overview':
        return Icons.view_agenda_outlined;
      case 'Education Required in India':
        return Icons.school_outlined;
      case 'Best Schools in India':
        return Icons.account_balance_outlined;
      case 'Work Environment':
        return Icons.business_center_outlined;
      case 'Salaries in India':
        return Icons.attach_money;
      case 'Industry Trends':
        return Icons.trending_up;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final isDarkTheme = themeData.brightness == Brightness.dark;

    final sectionColor = _getSectionColor();
    final sectionIcon = _getSectionIcon();

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => ElaborateDetail(
              title: title,
              career: career,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: sectionColor.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDarkTheme ? Colors.grey[700]! : Colors.grey[300]!,
            width: 1,
          ),
        ),
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    sectionIcon,
                    color: sectionColor,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: sectionColor,
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
              const Divider(height: 24),
              ...content.map((point) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 6),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: sectionColor.withOpacity(0.7),
                            shape: BoxShape.circle,
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
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => ElaborateDetail(
                          title: title,
                          career: career,
                        ),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.read_more,
                    size: 18,
                    color: sectionColor,
                  ),
                  label: const Text('Read more'),
                  style: TextButton.styleFrom(
                    foregroundColor: sectionColor,
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
