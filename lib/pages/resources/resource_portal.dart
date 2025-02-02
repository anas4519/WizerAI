import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/pages/career_exploration/screens/video_player.dart';
import 'package:career_counsellor/pages/resources/widgets/quiz_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ResourcePortal extends StatefulWidget {
  const ResourcePortal({super.key});

  @override
  State<ResourcePortal> createState() => _ResourcePortalState();
}

class _ResourcePortalState extends State<ResourcePortal> {
  List<String> savedRecommendations = [];
  bool isLoading = true;
  List<YouTubeVideo> youtubeVideos = [];

  // This variable keeps track of the currently selected button index.
  int selectedFilterIndex = 0;

  List<bool> _selectedFilters = [true, false, false]; // Default: "All"

  @override
  void initState() {
    initVideos();
    super.initState();
  }

  Future<void> _fetchYouTubeVideos() async {
    try {
      List<YouTubeVideo> fetchedVideos = [];

      for (String recommendation in savedRecommendations) {
        final String searchQuery = 'How to become a $recommendation';
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
              fetchedVideos.add(
                YouTubeVideo(
                  title: snippet['title'],
                  url:
                      'https://www.youtube.com/watch?v=${items[0]['id']['videoId']}',
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Error fetching YouTube videos: ${e.toString()}')),
        );
      });
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
    await _fetchYouTubeVideos();
  }

  void _toggleFilter(int index) {
    setState(() {
      selectedFilterIndex = index;
    });
    // Implement filtering logic here if needed
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final iconSize = screenWidth * 0.06;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quizzes',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: screenHeight * 0.02),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // First Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuizIcon(
                      icon: Icon(
                        CupertinoIcons.chat_bubble_2,
                        size: iconSize,
                      ),
                      title: 'Communication Skills',
                    ),
                    QuizIcon(
                      icon: Icon(
                        CupertinoIcons.question_circle,
                        size: iconSize,
                      ),
                      title: 'Problem Solving',
                    ),
                    QuizIcon(
                      icon: Icon(
                        Icons.group,
                        size: iconSize,
                      ),
                      title: 'Teamwork',
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Second Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuizIcon(
                      icon: Icon(
                        Icons.autorenew,
                        size: iconSize,
                      ),
                      title: 'Flexibility',
                    ),
                    QuizIcon(
                      icon: Icon(
                        Icons.leaderboard,
                        size: iconSize,
                      ),
                      title: 'Leadership Skills',
                    ),
                    QuizIcon(
                      icon: Icon(
                        Icons.access_time,
                        size: iconSize,
                      ),
                      title: 'Time Management',
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.02),

                // Third Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    QuizIcon(
                      icon: Icon(
                        Icons.search,
                        size: iconSize,
                      ),
                      title: 'Attention to Detail',
                    ),
                    QuizIcon(
                      icon: Icon(
                        Icons.brush_outlined,
                        size: iconSize,
                      ),
                      title: 'Creativity',
                    ),
                    QuizIcon(
                      icon: Icon(
                        Icons.note_alt_outlined,
                        size: iconSize,
                      ),
                      title: 'Custom',
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.04),
            Text(
              'Recommended Videos',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: screenHeight * 0.02),

            // Horizontal List of Buttons with selected styling
            SizedBox(
              height: 50, // Fixed height for the horizontal list
              child: ListView.builder(
                scrollDirection: Axis.horizontal, // Horizontal scrolling
                itemCount: savedRecommendations.length, // Number of items
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: ElevatedButton(
                      onPressed: () {
                        
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedFilterIndex == index
                            ? Colors.pink // Selected button colour
                            : Colors.grey[100], // Unselected button colour
                      ),
                      child: Text(savedRecommendations[index]),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: screenHeight * 0.02),
          ],
        ),
      ),
    );
  }
}
