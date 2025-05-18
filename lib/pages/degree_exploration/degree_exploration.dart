import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/degree_exploration/widgets/grid_member.dart';
import 'package:flutter/material.dart';

class DegreeExplorationPage extends StatefulWidget {
  const DegreeExplorationPage({super.key});

  @override
  State<DegreeExplorationPage> createState() => _DegreeExplorationPageState();
}

class _DegreeExplorationPageState extends State<DegreeExplorationPage> {
  final TextEditingController _searchController = TextEditingController();
  bool isSearchFocused = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.primaryColor.withOpacity(0.1),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: screenWidth * 0.04,
            right: screenWidth * 0.04,
            bottom: screenHeight * 0.02,
            top: screenHeight * 0.1,
          ),
          child: Column(
            children: [
              Focus(
                onFocusChange: (focused) {
                  setState(() => isSearchFocused = focused);
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: screenHeight * 0.07,
                  decoration: BoxDecoration(
                    color: isDarkMode ? Colors.grey[800] : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSearchFocused
                          ? Colors.pink
                          : (isDarkMode
                              ? Colors.grey[700]!
                              : Colors.grey[200]!),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isSearchFocused
                            ? (isDarkMode
                                ? Colors.pink.withOpacity(0.2)
                                : Colors.pink.withOpacity(0.1))
                            : (isDarkMode
                                ? Colors.black.withOpacity(0.3)
                                : Colors.grey.withOpacity(0.1)),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const SizedBox(width: 16),
                      Icon(
                        Icons.search_rounded,
                        color: isSearchFocused
                            ? (isDarkMode ? Colors.pink[300] : Colors.pink)
                            : (isDarkMode ? Colors.grey[400] : Colors.grey),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.sentences,
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.black,
                          ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Search a degree...',
                            hintStyle: TextStyle(
                              color: isDarkMode
                                  ? Colors.grey[500]
                                  : Colors.grey[400],
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: GridView.builder(
                  itemCount: degree_categories.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (context, index) {
                    final category = degree_categories[index];
                    return GridMember(
                      isDarkMode: isDarkMode,
                      category: category,
                      idx: index,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
