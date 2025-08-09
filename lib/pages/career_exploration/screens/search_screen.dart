import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/career_exploration/screens/career_details_page.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<String> displayList = [];
  final _searchController = TextEditingController();
  bool isSearchFocused = false;

  @override
  void initState() {
    super.initState();
    displayList = Constants.popularCareers;
  }

  void updateList(String value) {
    setState(() {
      if (value.isEmpty) {
        displayList = Constants.popularCareers;
      } else {
        displayList = Constants.popularCareers
            .where(
                (career) => career.toLowerCase().contains(value.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDarkMode
                ? [
                    Colors.grey[900]!,
                    Colors.black,
                    Colors.black,
                    Colors.grey[900]!,
                  ]
                : [
                    Colors.pink.shade50,
                    Colors.white,
                    Colors.white,
                    Colors.purple.shade50,
                  ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Discover Your',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w600,
                          color: isDarkMode ? Colors.white70 : Colors.grey[800],
                        ),
                      ),
                      const Text(
                        'Dream Career',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.03),
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
                            ? (Colors.pink)
                            : (isDarkMode
                                ? Colors.grey[700]!
                                : Colors.grey[200]!),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: isSearchFocused
                              ? (isDarkMode
                                  ? Colors.pink.withValues(alpha: 0.2)
                                  : Colors.pink.withValues(alpha: 0.1))
                              : (isDarkMode
                                  ? Colors.black.withValues(alpha: 0.3)
                                  : Colors.grey.withValues(alpha: 0.1)),
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
                            onChanged: (value) => updateList(value),
                            controller: _searchController,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.sentences,
                            style: TextStyle(
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Search for your ideal career...',
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
                SizedBox(height: screenHeight * 0.03),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    displayList.isEmpty
                        ? 'No Results Found'
                        : 'Popular Careers',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDarkMode ? Colors.white70 : Colors.grey[800],
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Expanded(
                  child: displayList.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off_rounded,
                                size: 80,
                                color: isDarkMode
                                    ? Colors.grey[700]
                                    : Colors.grey[300],
                              ),
                              SizedBox(height: screenHeight * 0.02),
                              Text(
                                "Can't find what you're looking for?",
                                style: TextStyle(
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => CareerDetailsPage(
                                        title: _searchController.text),
                                  ));
                                },
                                child: const Text(
                                  'Explore This Career',
                                  style: TextStyle(
                                    color: Colors.pink,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount: displayList.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode
                                    ? Colors.grey[900]
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: isDarkMode
                                        ? Colors.black.withValues(alpha: 0.3)
                                        : Colors.grey.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                title: Text(
                                  displayList[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Colors.black87,
                                  ),
                                ),
                                trailing: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 18,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey,
                                ),
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (ctx) => CareerDetailsPage(
                                        title: displayList[index]),
                                  ));
                                },
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
