import 'package:career_counsellor/bloc/degree_exploration/degree_exploration_bloc.dart';
import 'package:career_counsellor/bloc/degree_exploration/degree_exploration_event.dart';
import 'package:career_counsellor/bloc/degree_exploration/degree_exploration_state.dart';
import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/degree_exploration/widgets/degree_tile.dart';
import 'package:career_counsellor/pages/degree_exploration/widgets/grid_member.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DegreeExplorationPage extends StatefulWidget {
  const DegreeExplorationPage({super.key});

  @override
  State<DegreeExplorationPage> createState() => _DegreeExplorationPageState();
}

class _DegreeExplorationPageState extends State<DegreeExplorationPage>
    with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool isSearchFocused = false;
  late DegreeExplorationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = DegreeExplorationBloc();
    _bloc.add(LoadDegrees());
  }

  @override
  void dispose() {
    _searchController.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _bloc.add(SearchDegrees(query));
  }

  void _clearSearch() {
    _searchController.clear();
    _bloc.add(ClearSearch());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => _bloc,
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor.withValues(alpha: 0.08),
                theme.scaffoldBackgroundColor.withValues(alpha: 0.95),
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
                              ? Colors.pink.withValues(alpha: 0.8)
                              : (isDarkMode
                                  ? Colors.grey[700]!.withValues(alpha: 0.5)
                                  : Colors.grey[200]!),
                          width: isSearchFocused ? 2.5 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: isSearchFocused
                                ? Colors.pink.withValues(alpha: 0.15)
                                : (isDarkMode
                                    ? Colors.black.withValues(alpha: 0.2)
                                    : Colors.grey.withValues(alpha: 0.08)),
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
                              onChanged: _onSearchChanged,
                              style: TextStyle(
                                color:
                                    isDarkMode ? Colors.white : Colors.black87,
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
                          BlocBuilder<DegreeExplorationBloc,
                              DegreeExplorationState>(
                            builder: (context, state) {
                              if (state is DegreeExplorationLoaded &&
                                  state.isSearching) {
                                return GestureDetector(
                                  onTap: _clearSearch,
                                  child: Icon(
                                    Icons.clear,
                                    size: 20,
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[500],
                                  ),
                                );
                              }
                              return const SizedBox(width: 12);
                            },
                          ),
                          const SizedBox(width: 12),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.035),

                  // Content Section
                  Expanded(
                    child: BlocBuilder<DegreeExplorationBloc,
                        DegreeExplorationState>(
                      builder: (context, state) {
                        if (state is DegreeExplorationLoaded) {
                          if (state.isSearching) {
                            // Show search results
                            return _buildSearchResults(state, isDarkMode);
                          } else {
                            // Show grid
                            return _buildGrid(screenWidth);
                          }
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResults(DegreeExplorationLoaded state, bool isDarkMode) {
    if (state.searchResults.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: isDarkMode ? Colors.grey[600] : Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No degrees found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Try a different search term',
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.grey[500] : Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: state.searchResults.length,
      itemBuilder: (context, index) {
        final degree = state.searchResults[index];
        return DegreeTile(
            isDarkMode: isDarkMode, index: index, courseName: degree);
      },
    );
  }

  Widget _buildGrid(double screenWidth) {
    return GridView.builder(
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
            isDarkMode: Theme.of(context).brightness == Brightness.dark,
            category: category,
            idx: index,
          ),
        );
      },
    );
  }
}
