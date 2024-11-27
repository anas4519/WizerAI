import 'package:career_counsellor/pages/career_exploration/screens/elaborate_detail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConsSection extends StatelessWidget {
  const ConsSection(
      {super.key,
      required this.title,
      required this.content,
      required this.career});
  final String title;
  final List<String> content;
  final String career;

  @override
  Widget build(BuildContext context) {
    // final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (ctx) => ElaborateDetail(title: title, career: career)));
      },
      child: Card(
        elevation: 2,
        shadowColor: isDarkTheme ? Colors.grey : Colors.black,
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade900,
                ),
              ),
              const SizedBox(height: 12),
              ...content.map((point) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(CupertinoIcons.exclamationmark_triangle_fill,
                            color: Colors.red.shade900, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            point,
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
