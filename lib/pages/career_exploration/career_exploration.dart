import 'package:career_counsellor/pages/ai_guidance/screens/select_education.dart';
import 'package:career_counsellor/pages/career_exploration/screens/career_details.dart';
import 'package:career_counsellor/pages/career_exploration/screens/search_screen.dart';
import 'package:career_counsellor/pages/profile/profile_screen.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_ce/hive.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CareerExploration extends StatefulWidget {
  const CareerExploration({super.key});

  @override
  State<CareerExploration> createState() => _CareerExplorationState();
}

class _CareerExplorationState extends State<CareerExploration> {
  List<String> daimonSuggestions = [];
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = true;

  @override
  void initState() {
    fetchSuggestions();
    super.initState();
  }

  Future<void> fetchSuggestions() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();

      setState(() {
        daimonSuggestions = data['suggestions'] != null
            ? (data['suggestions'] as List<dynamic>)
                .map((e) => e.toString())
                .toList()
            : _getDefaultSuggestions();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        daimonSuggestions = _getDefaultSuggestions();
        _isLoading = false;
      });
    }
  }

  List<String> _getDefaultSuggestions() {
    return [
      'Software Engineering',
      'Data Science',
      'Digital Marketing',
      'UX/UI Design',
      'Product Management'
    ];
  }

  final List<Map<String, dynamic>> careerDetails = [
    {
      'image': 'assets/career_images/career_1.png',
      'title': 'Software Development',
      'description': 'Explore the world of coding and software development',
      'color': const Color(0xFF4285F4),
      'icon': Icons.code,
    },
    {
      'image': 'assets/career_images/career_2.png',
      'title': 'Teaching',
      'description': 'Shape the future through education and mentoring',
      'color': const Color(0xFF0F9D58),
      'icon': Icons.school,
    },
    {
      'image': 'assets/career_images/career_3.png',
      'title': 'Neurobiology',
      'description': 'Discover the mysteries of the brain and nervous system',
      'color': const Color(0xFFF4B400),
      'icon': Icons.biotech,
    },
    {
      'image': 'assets/career_images/career_4.png',
      'title': 'Healthcare',
      'description': 'Make a difference in people\'s lives through healthcare',
      'color': const Color(0xFFDB4437),
      'icon': Icons.medical_services,
    },
    {
      'image': 'assets/career_images/career_5.png',
      'title': 'Financial Analysis',
      'description': 'Navigate the complex world of finance and investments',
      'color': const Color(0xFF4A148C),
      'icon': Icons.trending_up,
    },
  ];

  void _handleImageTap(int index) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (ctx) =>
            CareerDetails(title: careerDetails[index]['title']!)));
  }

  final userBox = Hive.box('user_box');

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).primaryColor,
          ),
        ),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              CupertinoIcons.search,
              color: Theme.of(context).primaryColor,
            ),
          ),
          onPressed: () async {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SearchScreen()));
          },
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: GestureDetector(
              onTap: () {
                if (userBox.get('interests') == null) {
                  showErrorSnackBar(
                      context, 'Take the survey to view your profile.');
                } else {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) => const ProfileScreen()),
                  );
                }
              },
              child: CircleAvatar(
                backgroundColor:
                    Theme.of(context).primaryColor.withValues(alpha: 0.1),
                child: Icon(
                  Icons.person,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          )
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor.withValues(alpha: 0.1),
              Theme.of(context).scaffoldBackgroundColor,
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.04,
            vertical: screenWidth * 0.02,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screenHeight * 0.125,
              ),
              Container(
                padding: EdgeInsets.all(screenWidth * 0.05),
                margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDarkTheme
                        ? [
                            Colors.indigo.shade900,
                            Colors.purple.shade900,
                          ]
                        : [
                            Colors.indigo.shade100,
                            Colors.purple.shade100,
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      'Discover Your Path',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.playfairDisplay(
                        color:
                            isDarkTheme ? Colors.white : Colors.indigo.shade800,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Explore new possibilities and take the first step today!',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                        color: isDarkTheme
                            ? Colors.white70
                            : Colors.indigo.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (ctx) => const SelectEducation()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.08,
                          vertical: screenHeight * 0.015,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: const Text('Take Career Assessment'),
                    ),
                  ],
                ),
              ),

              // Trending section with improved header
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.01),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.trending_up,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    const Text(
                      'Trending Careers',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.015),

              // Improved carousel with overlay gradient and better formatting
              SizedBox(
                height: screenHeight * 0.25,
                child: CarouselView(
                  onTap: _handleImageTap,
                  itemExtent: screenWidth * 0.85,
                  children: List.generate(5, (index) {
                    return Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Main image with improved quality indication
                            Image.asset(
                              careerDetails[index]['image']!,
                              fit: BoxFit.cover,
                            ),

                            // Gradient overlay for better text readability
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.7),
                                  ],
                                  stops: const [0.6, 1.0],
                                ),
                              ),
                            ),

                            // Bottom content with title and description
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      careerDetails[index]['title']!,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.005),
                                    Text(
                                      careerDetails[index]['description']!,
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12.0,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Tap indicator
                            Positioned(
                              top: 12,
                              right: 12,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withValues(alpha: 0.6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.touch_app,
                                      color: Colors.white,
                                      size: 14,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'Tap to explore',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),

              // WizerAI Suggestions with improved styling
              Padding(
                padding: EdgeInsets.only(left: screenWidth * 0.01),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .primaryColor
                            .withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).primaryColor,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.02),
                    const Text(
                      'WizerAI Suggestions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: screenHeight * 0.02),

              // Custom suggestions cards instead of ListTiles
              ...List.generate(5, (index) {
                return Container(
                  margin: EdgeInsets.only(bottom: screenHeight * 0.015),
                  decoration: BoxDecoration(
                    color: isDarkTheme ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) =>
                              CareerDetails(title: daimonSuggestions[index]),
                        ));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Row(
                          children: [
                            // Career Icon
                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: careerDetails[index]['color']
                                    .withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                careerDetails[index]['icon'],
                                color: careerDetails[index]['color'],
                                size: 20,
                              ),
                            ),
                            SizedBox(width: screenWidth * 0.03),

                            // Career Name
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    daimonSuggestions[index],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: screenHeight * 0.005),
                                  Text(
                                    'Recommended based on your profile',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDarkTheme
                                          ? Colors.grey[400]
                                          : Colors.grey[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Arrow indicator
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(height: screenHeight * 0.02),

              // Additional "Explore More" button
              Center(
                child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (ctx) => const SearchScreen()),
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.08,
                      vertical: screenHeight * 0.015,
                    ),
                  ),
                  child: Text(
                    'Explore More Careers',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              SizedBox(height: screenHeight * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}
