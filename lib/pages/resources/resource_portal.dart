import 'dart:convert';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/pages/career_exploration/screens/video_player.dart';
import 'package:career_counsellor/pages/courses/courses_page.dart';
import 'package:career_counsellor/pages/resources/widgets/quiz_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ResourcePortal extends StatefulWidget {
  const ResourcePortal({super.key});

  @override
  State<ResourcePortal> createState() => _ResourcePortalState();
}

class _ResourcePortalState extends State<ResourcePortal>
    with SingleTickerProviderStateMixin {
  List<String> savedRecommendations = [];
  bool isLoading = true;
  List<YouTubeVideo> youtubeVideos = [];
  List<YouTubeVideo> weaknesses = [];
  final SupabaseClient supabase = Supabase.instance.client;

  late AnimationController _animationController;

  // This variable keeps track of the currently selected button index.
  int selectedFilterIndex = 0;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    initVideos();
    super.initState();
    _animationController.forward();
  }

  Future<void> _fetchWeaknesses() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      if (data['weaknesses'] == null || data['weaknesses'].isEmpty) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      List<dynamic> temp = data['weaknesses']
          .split(',')
          .map((e) => e.toString().trim())
          .toList();

      for (String weakness in temp) {
        final String searchQuery = 'How to improve on $weakness';
        final Uri url = Uri.parse('https://www.googleapis.com/youtube/v3/search'
            '?part=snippet'
            '&q=${Uri.encodeComponent(searchQuery)}'
            '&type=video'
            '&maxResults=3'
            '&relevanceLanguage=en'
            '&key=${Constants.YOUTUBE_aPI_KEY}');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> items = data['items'];

          if (items.isNotEmpty) {
            for (var i = 0; i < items.length; i++) {
              final snippet = items[i]['snippet'];
              final videoId = items[i]['id']['videoId'];
              weaknesses.add(
                YouTubeVideo(
                  title: snippet['title'],
                  url: 'https://www.youtube.com/watch?v=$videoId',
                  thumbnailUrl: snippet['thumbnails']['medium']['url'],
                  channelTitle: snippet['channelTitle'],
                ),
              );
            }
          }
        } else {
          throw Exception('Failed to fetch videos for $weakness');
        }
      }

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching user data: $e');
    }
  }

  Future<void> _fetchYouTubeVideos() async {
    try {
      List<YouTubeVideo> fetchedVideos = [];

      for (String recommendation in savedRecommendations) {
        final String searchQuery = 'How to make a career as a $recommendation';
        final Uri url = Uri.parse('https://www.googleapis.com/youtube/v3/search'
            '?part=snippet'
            '&q=${Uri.encodeComponent(searchQuery)}'
            '&type=video'
            '&maxResults=5'
            '&relevanceLanguage=en'
            '&key=${Constants.YOUTUBE_aPI_KEY}');

        final response = await http.get(url);

        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          final List<dynamic> items = data['items'];

          if (items.isNotEmpty) {
            for (var i = 0; i < min(items.length, 5); i++) {
              final snippet = items[i]['snippet'];
              final videoId = items[i]['id']['videoId'];
              fetchedVideos.add(
                YouTubeVideo(
                  title: snippet['title'],
                  url: 'https://www.youtube.com/watch?v=$videoId',
                  thumbnailUrl: snippet['thumbnails']['medium']['url'],
                  channelTitle: snippet['channelTitle'],
                ),
              );
            }
          }
        } else {
          throw Exception('Failed to fetch videos for $recommendation');
        }
      }

      setState(() {
        youtubeVideos = fetchedVideos;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching YouTube videos: ${e.toString()}');
    }
  }

  Future<void> initVideos() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < 5; i++) {
      String? recommendation = prefs.getString('r_$i');
      if (recommendation != null) {
        savedRecommendations.add(recommendation);
      }
    }
    await _fetchWeaknesses();
    await _fetchYouTubeVideos();
  }

  void _toggleFilter(int index) {
    HapticFeedback.lightImpact();
    setState(() {
      selectedFilterIndex = index;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    youtubeVideos.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: screenHeight * 0.2,
            pinned: true,
            stretch: true,
            backgroundColor: Theme.of(context).primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor,
                      isDarkTheme
                          ? Colors.purple.shade900
                          : Colors.purple.shade300,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Icon(
                        Icons.circle,
                        size: screenWidth * 0.4,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Icon(
                        Icons.circle,
                        size: screenWidth * 0.3,
                        color: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: screenHeight * 0.04),
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white,
                            size: screenWidth * 0.1,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text(
                'Learning Resources',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(screenWidth * 0.02),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const CoursesPage(),
                    ));
                  },
                  icon: const Icon(
                    CupertinoIcons.device_laptop,
                    color: Colors.white,
                  ),
                  tooltip: 'Online Courses',
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(screenWidth * 0.04),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildSectionHeader(
                  context,
                  title: 'Skill Assessment Quizzes',
                  icon: Icons.quiz_outlined,
                  color: Colors.indigo,
                ),
                // const SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GridView.count(
                      shrinkWrap: true,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 10,
                      crossAxisCount: 3,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        QuizIcon(
                          icon: Icon(
                            CupertinoIcons.chat_bubble_2,
                            size: iconSize,
                            color: Colors.blue,
                          ),
                          title: 'Communication',
                        ),
                        QuizIcon(
                          icon: Icon(
                            CupertinoIcons.question_circle,
                            size: iconSize,
                            color: Colors.green,
                          ),
                          title: 'Problem Solving',
                        ),
                        QuizIcon(
                          icon: Icon(
                            Icons.group,
                            size: iconSize,
                            color: Colors.orange,
                          ),
                          title: 'Teamwork',
                        ),
                        QuizIcon(
                          icon: Icon(
                            CupertinoIcons.arrow_2_circlepath,
                            size: iconSize,
                            color: Colors.purple,
                          ),
                          title: 'Adaptability',
                        ),
                        QuizIcon(
                          icon: Icon(
                            Icons.leaderboard,
                            size: iconSize,
                            color: Colors.red,
                          ),
                          title: 'Leadership',
                        ),
                        QuizIcon(
                          icon: Icon(
                            CupertinoIcons.time,
                            size: iconSize,
                            color: Colors.teal,
                          ),
                          title: 'Time Management',
                        ),
                        QuizIcon(
                          icon: Icon(
                            CupertinoIcons.search,
                            size: iconSize,
                            color: Colors.brown,
                          ),
                          title: 'Attention to Detail',
                        ),
                        QuizIcon(
                          icon: Icon(
                            CupertinoIcons.paintbrush,
                            size: iconSize,
                            color: Colors.pink,
                          ),
                          title: 'Creativity',
                        ),
                        QuizIcon(
                          icon: Icon(
                            Icons.note_alt_rounded,
                            size: iconSize,
                            color: Colors.cyan,
                          ),
                          title: 'Custom',
                        ),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.03),

                _buildSectionHeader(
                  context,
                  title: 'Recommended Career Videos',
                  icon: Icons.play_circle_outline,
                  color: Colors.red,
                ),
                const SizedBox(height: 12),

                if (savedRecommendations.isNotEmpty)
                  SizedBox(
                    height: 75,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: savedRecommendations.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: ElevatedButton(
                            onPressed: () => _toggleFilter(index),
                            style: ElevatedButton.styleFrom(
                              elevation: selectedFilterIndex == index ? 4 : 0,
                              backgroundColor: selectedFilterIndex == index
                                  ? Theme.of(context).primaryColor
                                  : isDarkTheme
                                      ? Colors.grey[800]
                                      : Colors.grey[300],
                              foregroundColor: selectedFilterIndex == index
                                  ? Colors.white
                                  : Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            child: Text(savedRecommendations[index]),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Complete career assessment to get personalized recommendations.',
                              style: TextStyle(fontSize: 14),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: screenHeight * 0.02),

                // Video content with loading indicator
                if (isLoading)
                  Center(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          'Loading resources...',
                          style: TextStyle(
                            color: isDarkTheme
                                ? Colors.grey[400]
                                : Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                else if (youtubeVideos.isEmpty)
                  _buildEmptyState(
                    icon: Icons.movie_creation_outlined,
                    message: 'No videos available for this category yet',
                  )
                else
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < 5; i++)
                            if ((selectedFilterIndex * 5 + i) <
                                youtubeVideos.length)
                              _buildVideoItem(
                                context,
                                youtubeVideos[selectedFilterIndex * 5 + i],
                                index: i,
                              ),
                        ],
                      ),
                    ),
                  ),

                SizedBox(height: screenHeight * 0.03),

                // Weaknesses Section
                _buildSectionHeader(
                  context,
                  title: 'Skill Development Resources',
                  icon: Icons.trending_up,
                  color: Colors.green,
                ),
                const SizedBox(height: 12),

                weaknesses.isEmpty
                    ? _buildEmptyState(
                        icon: Icons.build_circle_outlined,
                        message:
                            'Complete your profile to get personalized skill development resources',
                        actionText: 'Update Profile',
                        onAction: () {
                          // Navigate to profile page
                        },
                      )
                    : Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 12.0, left: 4.0),
                                child: Text(
                                  'Resources to help you develop essential skills',
                                  style: TextStyle(
                                    color: isDarkTheme
                                        ? Colors.grey[300]
                                        : Colors.grey[700],
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                              for (int i = 0; i < weaknesses.length; i++)
                                _buildVideoItem(
                                  context,
                                  weaknesses[i],
                                  index: i + 5, // offset the animation
                                ),
                            ],
                          ),
                        ),
                      ),

                SizedBox(height: screenHeight * 0.03),

                // Additional resources section (new)
                _buildSectionHeader(
                  context,
                  title: 'Additional Resources',
                  icon: Icons.menu_book_outlined,
                  color: Colors.amber,
                ),
                const SizedBox(height: 12),

                // Resource buttons (new)
                Row(
                  children: [
                    Expanded(
                      child: _buildResourceButton(
                        context,
                        icon: Icons.book_outlined,
                        title: 'Articles',
                        color: Colors.blue,
                        onTap: () {
                          // Navigate to articles section
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildResourceButton(
                        context,
                        icon: Icons.school_outlined,
                        title: 'Courses',
                        color: Colors.green,
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const CoursesPage(),
                          ));
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildResourceButton(
                        context,
                        icon: Icons.people_outline,
                        title: 'Mentors',
                        color: Colors.purple,
                        onTap: () {
                          // Navigate to mentors section
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildResourceButton(
                        context,
                        icon: Icons.workspace_premium_outlined,
                        title: 'Certificates',
                        color: Colors.orange,
                        onTap: () {
                          // Navigate to certificates section
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.05),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to personalized learning plan or AI assistant
        },
        icon: const Icon(Icons.assistant),
        label: const Text('Get Guidance'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }

  // Helper method to build section headers with consistent styling
  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // Helper method to build empty state widgets
  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            if (actionText != null && onAction != null) ...[
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text(actionText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // Helper method for video items with staggered animations
  Widget _buildVideoItem(BuildContext context, YouTubeVideo video,
      {required int index}) {
    // Calculate staggered animation delay
    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(
          index * 0.1, // staggered start
          min(1.0, index * 0.1 + 0.4), // staggered end
          curve: Curves.easeOut,
        ),
      ),
    );

    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.2, 0),
          end: Offset.zero,
        ).animate(animation),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (ctx) => VideoApp(video: video),
              ));
            },
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isDarkTheme ? Colors.grey[850] : Colors.grey[100],
              ),
              padding: const EdgeInsets.all(8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Thumbnail with play button overlay
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          width: screenWidth * 0.3,
                          height: screenHeight * 0.08,
                          fit: BoxFit.cover,
                          imageUrl: video.thumbnailUrl,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[700],
                            child: const Center(
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[800],
                            child: const Icon(
                              Icons.error_outline,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.play_arrow,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 12,
                              color: isDarkTheme
                                  ? Colors.grey[400]
                                  : Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                video.channelTitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkTheme
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
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

  // Helper method for resource buttons
  Widget _buildResourceButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isDarkTheme ? color.withOpacity(0.2) : color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 32,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: isDarkTheme ? Colors.white : Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
