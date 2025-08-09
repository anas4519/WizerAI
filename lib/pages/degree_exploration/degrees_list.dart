import 'package:career_counsellor/pages/degree_exploration/utils/lists.dart';
import 'package:career_counsellor/pages/degree_exploration/widgets/course_list.dart';
import 'package:career_counsellor/pages/degree_exploration/widgets/toggle_button.dart';
import 'package:flutter/material.dart';

class DegreesList extends StatefulWidget {
  const DegreesList({super.key, required this.title, required this.idx});
  final String title;
  final int idx;

  @override
  State<DegreesList> createState() => _DegreesListState();
}

class _DegreesListState extends State<DegreesList> {
  bool isBachelorsSelected = true;
  bool isMastersSelected = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 18,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Enhanced Toggle Buttons
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButton(
                    isSelected: isBachelorsSelected,
                    text: 'Bachelor\'s',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      setState(() {
                        isMastersSelected = false;
                        isBachelorsSelected = true;
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  ToggleButton(
                    isSelected: isMastersSelected,
                    text: 'Master\'s',
                    isDarkMode: isDarkMode,
                    onTap: () {
                      setState(() {
                        setState(() {
                          isMastersSelected = true;
                          isBachelorsSelected = false;
                        });
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: screenHeight * 0.04),

            // Count indicator
            Text(
              '${isBachelorsSelected ? mainList[widget.idx][0].length : mainList[widget.idx][1].length} programs available',
              style: TextStyle(
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 16),

            // Enhanced List
            CourseList(
                idx: widget.idx, isBachelorsSelected: isBachelorsSelected)
          ],
        ),
      ),
    );
  }
}
