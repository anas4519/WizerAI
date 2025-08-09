import 'package:career_counsellor/pages/degree_exploration/degrees_list.dart';
import 'package:flutter/material.dart';

class GridMember extends StatelessWidget {
  const GridMember(
      {super.key,
      required this.isDarkMode,
      required this.category,
      required this.idx});
  final bool isDarkMode;
  final Map<String, dynamic> category;
  final int idx;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => DegreesList(
                    title: category["name"],
                    idx: idx,
                  )),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            category["icon"],
            size: 36,
            color: Colors.pink,
          ),
          const SizedBox(height: 12),
          Text(
            category["name"],
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black87,
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
