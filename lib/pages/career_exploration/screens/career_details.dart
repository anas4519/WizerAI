import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/animated_fade_in.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/career_pathway_card.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/chat_with_bot.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/compatibility_check.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/cons_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/default_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/pros_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/youtube_section.dart';
import 'package:career_counsellor/widgets/info_container.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;
import 'package:lottie/lottie.dart';

class CareerDetails extends StatefulWidget {
  const CareerDetails({super.key, required this.title});
  final String title;

  @override
  State<CareerDetails> createState() => _CareerDetailsState();
}

class _CareerDetailsState extends State<CareerDetails> {
  bool isLoading = true;
  String? errorMessage;
  Map<String, List<String>> careerDetails = {};
  List<YouTubeVideo> youtubeVideos = [];
  String imageUrl = '';
  final aiCache = Hive.box('ai_cache');

  String apiKey = Constants.YOUTUBE_aPI_KEY;

  final List<String> sections = [
    'Overview',
    'Education Required in India',
    'Best Schools in India',
    'Work Environment',
    'Salaries in India',
    'Pros',
    'Cons',
    'Industry Trends',
    'YouTube Resources'
  ];

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    try {
      // Run these operations in parallel for faster loading
      await Future.wait([
        _fetchImagesFromPexels(),
        _generateContent(),
        _fetchYouTubeVideos(),
      ]);

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error initializing data: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Future<void> _fetchImagesFromPexels() async {
    const apiKey = PEXELS_API_KEY;
    const perPage = 1;
    final query = widget.title;

    try {
      final url = Uri.parse(
          'https://api.pexels.com/v1/search?query=$query&per_page=$perPage');
      final response = await http.get(
        url,
        headers: {
          'Authorization': apiKey,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final photos = data['photos'] as List<dynamic>;
        if (photos.isNotEmpty) {
          setState(() {
            imageUrl = photos[0]['src']['landscape'];
          });
        }
      } else {
        print(
            'Error for query "$query": ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception fetching image: $e');
    }
  }

  Future<void> _fetchYouTubeVideos() async {
    try {
      final String searchQuery =
          'How to become a ${widget.title} in India'; // Search query for YouTube
      final Uri url = Uri.parse('https://www.googleapis.com/youtube/v3/search'
          '?part=snippet'
          '&q=${Uri.encodeComponent(searchQuery)}'
          '&type=video'
          '&maxResults=4'
          '&relevanceLanguage=en'
          '&videoEmbeddable=true'
          '&key=$apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'];

        youtubeVideos = items.map((item) {
          final snippet = item['snippet'];
          return YouTubeVideo(
            title: snippet['title'],
            url: 'https://www.youtube.com/watch?v=${item['id']['videoId']}',
            thumbnailUrl: snippet['thumbnails']['high']
                ['url'], // Get higher quality thumbnails
            channelTitle: snippet['channelTitle'],
          );
        }).toList();

        if (youtubeVideos.isNotEmpty) {
          careerDetails['YouTube Resources'] = youtubeVideos
              .map((video) =>
                  '${video.title} by ${video.channelTitle} (${video.url})')
              .toList();
        }
      } else {
        throw Exception(
            'Failed to fetch YouTube videos: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching YouTube videos: ${e.toString()}');
    }
  }

  bool _isDataExpired(DateTime storedDate) {
    final now = DateTime.now();
    final difference = now.difference(storedDate);
    return difference.inDays >= 10;
  }

  Future<void> _generateContent() async {
    final cacheKey =
        'career_${widget.title.toLowerCase().replaceAll(' ', '_')}';

    try {
      if (aiCache.containsKey(cacheKey)) {
        final cachedData = aiCache.get(cacheKey);
        final timestamp = cachedData[1] as DateTime;

        if (!_isDataExpired(timestamp)) {
          final cachedResponse = cachedData[0] as String;
          _parseCareerDetails(cachedResponse);
          return;
        }
      }

      final model = google_ai.GenerativeModel(
        model: 'gemini-2.0-flash',
        apiKey: GEMINI_API_KEY,
      );

      String prompt = '''
You are a professional career counselor specializing in Indian careers and education. 
Generate comprehensive, accurate, and up-to-date information about the '${widget.title}' career path in India.

Focus on providing factual, well-researched information with practical insights relevant to students and job seekers in India.

Return ONLY a valid JSON object with the following structure:
{
  "Overview": [
    "Detailed description of what the ${widget.title} profession entails",
    "Key responsibilities and daily activities",
    "Types of organizations and industries employing ${widget.title}s",
    "Required skills and aptitudes"
  ],
  "Education Required in India": [
    "Minimum educational qualifications",
    "Recommended degrees and specializations",
    "Professional certifications required or beneficial",
    "Duration of educational programs",
    "Alternative educational pathways"
  ],
  "Best Schools in India": [
    "Top institutions offering related programs",
    "Notable programs with good placement records",
    "Specialized institutions with industry connections",
    "Institutions offering scholarships or financial aid",
    "Colleges with best faculty and infrastructure"
  ],
  "Work Environment": [
    "Typical workplace settings",
    "Work schedule and work-life balance",
    "Team dynamics and collaboration patterns",
    "Physical and mental demands",
    "Remote work opportunities"
  ],
  "Salaries in India": [
    "Entry-level salary ranges in rupees",
    "Mid-career salary expectations",
    "Senior-level compensation packages",
    "Salary variations by location in India",
    "Comparison with related roles"
  ],
  "Pros": [
    "Career growth opportunities",
    "Job security factors",
    "Work satisfaction aspects",
    "Financial benefits",
    "Personal development opportunities"
  ],
  "Cons": [
    "Common challenges faced",
    "Work-related stress factors",
    "Industry-specific limitations",
    "Potential career plateaus",
    "Competitive aspects"
  ],
  "Industry Trends": [
    "Recent developments affecting this career",
    "Emerging technologies impacting the role",
    "Future job prospects in India",
    "Skills becoming increasingly valuable",
    "Changes in hiring patterns"
  ]
}

Each point should be a complete, informative sentence with specific details about the '${widget.title}' career in India.
Do not include any explanations, notes, or text outside the JSON structure.
Ensure the JSON is valid with properly escaped characters.
''';

      final content = [google_ai.Content.text(prompt)];
      var modelResult = await model.generateContent(content);
      String response = modelResult.text?.trim() ?? '';

      // Clean up response to extract valid JSON
      if (response.contains("```json")) {
        response = response.substring(response.indexOf("```json") + 7);
      } else if (response.startsWith("```")) {
        response = response.substring(3);
      }

      if (response.contains("```")) {
        response = response.substring(0, response.lastIndexOf("```"));
      }

      response = response.trim();

      // Cache the response
      aiCache.put(cacheKey, [response, DateTime.now()]);

      // Parse the response
      _parseCareerDetails(response);
    } catch (e) {
      print('Error generating content: ${e.toString()}');
      setState(() {
        errorMessage = 'Error generating career information: ${e.toString()}';
      });
    }
  }

  void _parseCareerDetails(String jsonString) {
    try {
      // Attempt to parse as JSON first
      Map<String, dynamic> jsonData = json.decode(jsonString);

      setState(() {
        careerDetails = jsonData.map((key, value) {
          List<String> stringList = [];
          if (value is List) {
            stringList = value.map((item) => item.toString()).toList();
          }
          return MapEntry(key, stringList);
        });
      });
    } catch (jsonError) {
      print("JSON parsing error: $jsonError");
      print("Attempted to parse: $jsonString");

      // Fallback parsing for malformed JSON
      _parseMalformedResponse(jsonString);
    }
  }

  void _parseMalformedResponse(String response) {
    Map<String, List<String>> parsedSections = {};
    String currentSection = '';
    List<String> currentPoints = [];

    // Split by lines and process
    List<String> lines = response.split('\n');

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      // Check for section headers
      if (line.startsWith('"') && line.contains('":')) {
        // JSON format section header
        if (currentSection.isNotEmpty && currentPoints.isNotEmpty) {
          parsedSections[currentSection] = List<String>.from(currentPoints);
          currentPoints = [];
        }
        currentSection = line.split('":')[0].replaceAll('"', '').trim();
      } else if (line.startsWith(RegExp(r'[A-Z]')) && line.endsWith(':')) {
        // Text format section header
        if (currentSection.isNotEmpty && currentPoints.isNotEmpty) {
          parsedSections[currentSection] = List<String>.from(currentPoints);
          currentPoints = [];
        }
        currentSection = line.replaceAll(':', '').trim();
      } else if (line.contains("[") && !line.contains("]")) {
        // Start of an array in JSON
        currentSection =
            line.split("[")[0].replaceAll('"', '').replaceAll(':', '').trim();
        currentPoints = [];
      } else if (line.startsWith(RegExp(r'[\-\*\•]')) ||
          line.startsWith(RegExp(r'\d+\.'))) {
        // Bullet point
        String cleanedLine =
            line.replaceAll(RegExp(r'[\-\*\•\d+\.]'), '').trim();
        if (cleanedLine.isNotEmpty && currentSection.isNotEmpty) {
          // Remove quotes if present
          cleanedLine =
              cleanedLine.replaceAll(RegExp(r'^"|"$|^"|"$'), '').trim();
          cleanedLine = cleanedLine.replaceAll(RegExp(r"^'|'$"), '').trim();
          if (cleanedLine.endsWith(',')) {
            cleanedLine = cleanedLine.substring(0, cleanedLine.length - 1);
          }
          currentPoints.add(cleanedLine);
        }
      } else if (line.contains('"') && line.endsWith(',')) {
        // JSON array item
        String cleanedLine = line.replaceAll(RegExp(r'^"|"$|^"|"$'), '').trim();
        cleanedLine = cleanedLine.replaceAll(',', '').trim();
        if (cleanedLine.isNotEmpty && currentSection.isNotEmpty) {
          currentPoints.add(cleanedLine);
        }
      }
    }

    // Add the last section if it exists
    if (currentSection.isNotEmpty && currentPoints.isNotEmpty) {
      parsedSections[currentSection] = List<String>.from(currentPoints);
    }

    setState(() {
      careerDetails = parsedSections;
    });
  }

  Widget _buildSection(String title, List<String> content) {
    if (content.isEmpty) return const SizedBox.shrink();

    if (title == 'YouTube Resources') {
      return youtubeVideos.isNotEmpty
          ? YoutubeSection(youtubeVideos: youtubeVideos)
          : const SizedBox.shrink();
    }
    if (title == 'Pros') {
      return ProsSection(title: title, content: content, career: widget.title);
    }
    if (title == 'Cons') {
      return ConsSection(
        title: title,
        content: content,
        career: widget.title,
      );
    }
    return DefaultSection(
      title: title,
      content: content,
      career: widget.title,
    );
  }

  @override
  void dispose() {
    youtubeVideos.clear();
    careerDetails.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final isDarkTheme = themeData.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDarkTheme ? Colors.white : Colors.pink,
          ),
        ),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              setState(() {
                isLoading = true;
                errorMessage = null;
              });

              // Clear cache for this career to force refresh
              final cacheKey =
                  'career_${widget.title.toLowerCase().replaceAll(' ', '_')}';
              if (aiCache.containsKey(cacheKey)) {
                aiCache.delete(cacheKey);
              }

              await _initializeData();
            },
            tooltip: 'Refresh data',
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/animations/ai-loader1.json',
                    width: screenWidth * 0.3,
                    height: screenWidth * 0.3,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Text(
                      'Analyzing ${widget.title}...',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDarkTheme ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
            )
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Could not load career information',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDarkTheme ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          errorMessage!,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                isDarkTheme ? Colors.white70 : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton.icon(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                              errorMessage = null;
                            });
                            await _initializeData();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Try Again'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () async {
                    setState(() {
                      isLoading = true;
                    });
                    await _initializeData();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (imageUrl.isNotEmpty)
                          AnimatedFadeIn(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              margin: const EdgeInsets.only(bottom: 24),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: FancyShimmerImage(
                                  imageUrl: imageUrl,
                                  errorWidget: Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image_not_supported,
                                        size: 50),
                                  ),
                                  width: screenWidth,
                                  height: screenHeight * 0.25,
                                  boxFit: BoxFit.cover,
                                  shimmerBackColor: Colors.grey[300]!,
                                  shimmerBaseColor: Colors.grey[200]!,
                                  shimmerHighlightColor: Colors.white,
                                ),
                              ),
                            ),
                          ),

                        // Content sections
                        ...sections
                            .where((section) =>
                                section != 'YouTube Resources' &&
                                careerDetails.containsKey(section) &&
                                (careerDetails[section]?.isNotEmpty ?? false))
                            .map((section) => AnimatedFadeIn(
                                  delay: Duration(
                                      milliseconds:
                                          100 * sections.indexOf(section)),
                                  child: _buildSection(
                                      section, careerDetails[section]!),
                                )),

                        // Additional cards
                        AnimatedFadeIn(
                          delay: const Duration(milliseconds: 500),
                          child: CareerPathwayCard(title: widget.title),
                        ),

                        if (youtubeVideos.isNotEmpty)
                          AnimatedFadeIn(
                              delay: const Duration(milliseconds: 600),
                              child:
                                  YoutubeSection(youtubeVideos: youtubeVideos)),

                        AnimatedFadeIn(
                          delay: const Duration(milliseconds: 700),
                          child: CompatibilityCheckCard(title: widget.title),
                        ),

                        AnimatedFadeIn(
                          delay: const Duration(milliseconds: 800),
                          child: ChatWithBot(title: widget.title),
                        ),

                        SizedBox(height: screenHeight * 0.02),

                        // Disclaimer
                        const InfoContainer(
                          text:
                              'This content is generated by AI and may sometimes contain inaccuracies or incomplete information. Please verify independently when necessary.',
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}
