import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/degree_exploration/widgets/grid_member.dart';
import 'package:flutter/material.dart';

class DegreeExplorationPage extends StatefulWidget {
  const DegreeExplorationPage({super.key});

  @override
  State<DegreeExplorationPage> createState() => _DegreeExplorationPageState();
}

class _DegreeExplorationPageState extends State<DegreeExplorationPage>
    with TickerProviderStateMixin {
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
              theme.primaryColor.withOpacity(0.08),
              theme.scaffoldBackgroundColor.withOpacity(0.95),
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenHeight * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenHeight * 0.02),

                // Title Section
                Text(
                  'Explore Degrees',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w700,
                    color: isDarkMode ? Colors.white : Colors.black87,
                    letterSpacing: -0.5,
                  ),
                ),
                SizedBox(height: screenHeight * 0.008),
                Text(
                  'Discover your perfect academic path',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                ),

                SizedBox(height: screenHeight * 0.04),

                // Enhanced Search Bar
                Focus(
                  onFocusChange: (focused) {
                    setState(() => isSearchFocused = focused);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutCubic,
                    height: screenHeight * 0.065,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[850] : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: isSearchFocused
                            ? Colors.pink.withOpacity(0.8)
                            : (isDarkMode
                                ? Colors.grey[700]!.withOpacity(0.5)
                                : Colors.grey[200]!),
                        width: isSearchFocused ? 2.5 : 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSearchFocused
                              ? Colors.pink.withOpacity(0.15)
                              : (isDarkMode
                                  ? Colors.black.withOpacity(0.2)
                                  : Colors.grey.withOpacity(0.08)),
                          blurRadius: isSearchFocused ? 20 : 8,
                          offset: const Offset(0, 6),
                          spreadRadius: isSearchFocused ? 2 : 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 20),
                        AnimatedScale(
                          scale: isSearchFocused ? 1.1 : 1.0,
                          duration: const Duration(milliseconds: 200),
                          child: Icon(
                            Icons.search_rounded,
                            size: 22,
                            color: isSearchFocused
                                ? Colors.pink
                                : (isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[500]),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search degrees and programs...',
                              hintStyle: TextStyle(
                                color: isDarkMode
                                    ? Colors.grey[500]
                                    : Colors.grey[400],
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.035),

                // Grid Section
                Expanded(
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: degree_categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: screenWidth > 600 ? 3 : 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.05,
                    ),
                    itemBuilder: (context, index) {
                      final category = degree_categories[index];
                      return AnimatedScale(
                        scale: 1.0,
                        duration: Duration(milliseconds: 100 + (index * 50)),
                        child: GridMember(
                          isDarkMode: isDarkMode,
                          category: category,
                          idx: index,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
