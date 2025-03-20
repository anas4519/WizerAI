import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/pages/career_exploration/screens/compatibility_check.dart';
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
      await _fetchImagesFromPexels();
      await _generateContent();
      await _fetchYouTubeVideos();
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
          imageUrl = photos[0]['src']['landscape'];
        }
      } else {
        print(
            'Error for query "$query": ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<void> _fetchYouTubeVideos() async {
    try {
      final String searchQuery = 'How to become a ${widget.title}';
      final Uri url = Uri.parse('https://www.googleapis.com/youtube/v3/search'
          '?part=snippet'
          '&q=${Uri.encodeComponent(searchQuery)}'
          '&type=video'
          '&maxResults=4'
          '&relevanceLanguage=en'
          '&key=$apiKey');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> items = data['items'];

        setState(() {
          youtubeVideos = items.map((item) {
            final snippet = item['snippet'];
            return YouTubeVideo(
              title: snippet['title'],
              url: 'https://www.youtube.com/watch?v=${item['id']['videoId']}',
              thumbnailUrl: snippet['thumbnails']['medium']['url'],
              channelTitle: snippet['channelTitle'],
            );
          }).toList();

          if (youtubeVideos.isNotEmpty) {
            careerDetails['YouTube Resources'] = youtubeVideos
                .map((video) =>
                    '${video.title} by ${video.channelTitle} (${video.url})')
                .toList();
          }
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch YouTube videos');
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching YouTube videos: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  bool checkIfOlderThan10Days(DateTime storedDate) {
    final now = DateTime.now();
    final difference = now.difference(storedDate);

    if (difference.inDays >= 10) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> _generateContent() async {
    final model = google_ai.GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: GEMINI_API_KEY,
    );

    String prompt = '''
You are a career counsellor. Generate the following information about the career '${widget.title}' in JSON format:

{
  "Overview": ["point 1", "point 2", "point 3"],
  "Education Required in India": ["point 1", "point 2", "point 3"],
  "Best Schools in India": ["point 1", "point 2", "point 3"],
  "Work Environment": ["point 1", "point 2", "point 3"],
  "Salaries in India": ["point 1", "point 2", "point 3"],
  "Pros": ["advantage 1", "advantage 2", "advantage 3"],
  "Cons": ["disadvantage 1", "disadvantage 2", "disadvantage 3"],
  "Industry Trends": ["trend 1", "trend 2", "trend 3"]
}

Provide only the JSON with no additional text or markdown formatting.
Ensure each section has at least 3-5 detailed bullet points.
''';

    final content = [google_ai.Content.text(prompt)];

    try {
      String? cachedResponse;

      if (aiCache.get(widget.title) != null &&
          !checkIfOlderThan10Days(aiCache.get(widget.title)[1])) {
        cachedResponse = aiCache.get(widget.title)[0];
      } else {
        var modelResult = await model.generateContent(content);

        String response = modelResult.text?.trim() ?? '';

        if (response.startsWith("```json")) {
          response = response.substring(7);
        }
        if (response.startsWith("```")) {
          response = response.substring(3);
        }
        if (response.endsWith("```")) {
          response = response.substring(0, response.length - 3);
        }

        response = response.trim();

        aiCache.put(widget.title, [response, DateTime.now()]);
        cachedResponse = response;
      }

      setState(() {
        try {
          Map<String, dynamic> jsonData = json.decode(cachedResponse!);

          careerDetails = jsonData.map((key, value) {
            List<String> stringList = [];
            if (value is List) {
              stringList = value.map((item) => item.toString()).toList();
            }
            return MapEntry(key, stringList);
          });
        } catch (jsonError) {
          print("JSON parsing error: $jsonError");
          print("Attempted to parse: $cachedResponse");

          Map<String, dynamic> sections = {};
          String currentSection = '';
          List<String> lines = cachedResponse!.split('\n');
          List<String> currentPoints = [];

          for (String line in lines) {
            line = line.trim();
            if (line.isEmpty) continue;

            if (line.startsWith(RegExp(r'\d\.')) ||
                (line.startsWith('**') && line.endsWith('**'))) {
              if (currentSection.isNotEmpty) {
                sections[currentSection] = List<String>.from(currentPoints);
                currentPoints = [];
              }
              currentSection = line.replaceAll(RegExp(r'[\d\.\*]'), '').trim();
            } else if (line.startsWith('•') ||
                line.startsWith('-') ||
                line.startsWith('*')) {
              String cleanedLine =
                  line.replaceAll(RegExp(r'[•\-\*]'), '').trim();
              if (cleanedLine.isNotEmpty) {
                currentPoints.add(cleanedLine);
              }
            }
          }

          if (currentSection.isNotEmpty && currentPoints.isNotEmpty) {
            sections[currentSection] = List<String>.from(currentPoints);
          }

          careerDetails = sections
              .map((key, value) => MapEntry(key, List<String>.from(value)));
        }

        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error generating content: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  Widget _buildYouTubeSection() {
    if (youtubeVideos.isEmpty) return const SizedBox.shrink();
    return YoutubeSection(youtubeVideos: youtubeVideos);
  }

  Widget _buildSection(String title, List<String> content) {
    if (title == 'YouTube Resources') {
      return _buildYouTubeSection();
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (ctx) => CompatibilityCheck(
                            career: widget.title,
                          )));
                },
                icon: const Icon(Icons.auto_awesome)),
          )
        ],
      ),
      body: isLoading
          ?
          // const Center(child: CircularProgressIndicator())
          Center(
              child: Lottie.asset(
                'assets/animations/ai-loader1.json',
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                fit: BoxFit.contain,
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
                      Center(
                          child: FancyShimmerImage(
                        boxDecoration: BoxDecoration(
                            border: Border.all(color: Colors.pink, width: 2)),
                        imageUrl: imageUrl,
                        errorWidget: const Icon(Icons.error),
                        width: screenWidth,
                        boxFit: BoxFit.fitWidth,
                        shimmerBackColor: Colors.grey,
                        shimmerBaseColor: Colors.grey,
                        shimmerHighlightColor: Colors.pink[200],
                      )),
                    ...sections
                        .where((section) =>
                            section != 'YouTube Resources' &&
                            careerDetails.containsKey(section))
                        .map((section) =>
                            _buildSection(section, careerDetails[section]!)),
                    CareerPathwayCard(title: widget.title),
                    if (youtubeVideos.isNotEmpty) _buildYouTubeSection(),
                    CompatibilityCheckCard(
                      title: widget.title,
                    ),
                    ChatWithBot(title: widget.title),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    const InfoContainer(
                        text:
                            'This content is generated by AI and may sometimes contain inaccuracies or incomplete information. Please verify independently when necessary.'),
                  ],
                ),
              ),
            ),
    );
  }
}
