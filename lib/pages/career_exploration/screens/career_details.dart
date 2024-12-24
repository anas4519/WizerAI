import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/pages/career_exploration/screens/career_detail_ai_guide.dart';
import 'package:career_counsellor/pages/career_exploration/screens/career_pathway.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/cons_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/default_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/pros_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/youtube_section.dart';
import 'package:career_counsellor/widgets/info_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gemini/flutter_gemini.dart';
import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

class CareerDetails extends StatefulWidget {
  const CareerDetails({super.key, required this.title});
  final String title;

  @override
  State<CareerDetails> createState() => _CareerDetailsState();
}

class _CareerDetailsState extends State<CareerDetails> {
  bool isLoading = true;
  String? errorMessage;
  final Gemini gemini = Gemini.instance;
  Map<String, List<String>> careerDetails = {};
  List<YouTubeVideo> youtubeVideos = [];

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
      await _generateInitialRecommendations();
      await _fetchYouTubeVideos();
    } catch (e) {
      setState(() {
        errorMessage = 'Error initializing data: ${e.toString()}';
        isLoading = false;
      });
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

  // Future<void> _generateInitialRecommendations() async {
  //   String prompt = '''
  //   You are a career counsellor. Generate the following information about the career '${widget.title}':
  //   1. Overview
  //   2. Education Required in India
  //   3. Best Schools in India
  //   4. Work Environment
  //   5. Salaries in India
  //   6. Pros (list only the advantages)
  //   7. Cons (list only the disadvantages)
  //   8. Industry Trends

  //   Format each section with its heading followed by bullet points. Separate sections with double newlines.
  //   ''';

  //   try {
  //     final result = await gemini.text(prompt);
  //     if (result?.content?.parts?[0].text != null) {
  //       String responseText = result!.content!.parts![0].text!;
  //       print(responseText);
  //       _parseResponse(responseText);
  //     } else {
  //       throw Exception('Empty response from Gemini');
  //     }
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Failed to load career information: ${e.toString()}';
  //       isLoading = false;
  //     });
  //   }
  // }

  Future<void> _generateInitialRecommendations() async {
    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: Constants.GEMINI_API_KEY,
    );

    String prompt = '''
  You are a career counsellor. Generate the following information about the career '${widget.title}':
  1. Overview
  2. Education Required in India
  3. Best Schools in India
  4. Work Environment
  5. Salaries in India
  6. Pros (list only the advantages)
  7. Cons (list only the disadvantages)
  8. Industry Trends

  Format each section with its heading followed by bullet points. Separate sections with double newlines.
  ''';

    final content = [google_ai.Content.text(prompt)];

    try {
      final result = await model.generateContent(content);
      // print(result.text);
      setState(() {
        if (result.text != null) {
          String response = result.text!;
          Map<String, dynamic> sections = {};
          String currentSection = '';
          List<String> lines = response.split('\n');
          List<String> currentPoints = [];
          for (String line in lines) {
            line = line.trim();
            if (line.isEmpty) continue;

            // Check for section headers (numbered or with asterisks)
            if (line.startsWith(RegExp(r'\d\.')) ||
                (line.startsWith('**') && line.endsWith('**'))) {
              if (currentSection.isNotEmpty) {
                sections[currentSection] = List<String>.from(currentPoints);
                currentPoints = [];
              }
              currentSection = line.replaceAll(RegExp(r'[\d\.\*]'), '').trim();
            }
            // Check for bullet points
            else if (line.startsWith('•') ||
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
          isLoading = false;
        }
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error generating content: ${e.toString()}';
        isLoading = false;
      });
    }
  }

  // void _parseResponse(String response) {
  //   try {
  //     Map<String, List<String>> parsedData = {};
  //     String currentSection = '';
  //     List<String> currentPoints = [];

  //     // Remove star symbols from the entire response
  //     response = response.replaceAll('*', '');

  //     final lines = response.split('\n');

  //     for (String line in lines) {
  //       line = line.trim();
  //       if (line.isEmpty) continue;

  //       bool isHeader = sections.any(
  //           (section) => line.toLowerCase().contains(section.toLowerCase()));

  //       if (isHeader) {
  //         if (currentSection.isNotEmpty) {
  //           parsedData[currentSection] = List.from(currentPoints);
  //           currentPoints.clear();
  //         }
  //         currentSection = sections.firstWhere(
  //             (section) => line.toLowerCase().contains(section.toLowerCase()),
  //             orElse: () => line);
  //       } else if (line.startsWith('-') || line.startsWith('•')) {
  //         currentPoints.add(line.replaceFirst(RegExp(r'^[•-]\s*'), ''));
  //       } else if (currentSection.isNotEmpty) {
  //         currentPoints.add(line);
  //       }
  //     }

  //     if (currentSection.isNotEmpty) {
  //       parsedData[currentSection] = List.from(currentPoints);
  //     }

  //     setState(() {
  //       careerDetails = parsedData;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       errorMessage = 'Error parsing career information: ${e.toString()}';
  //       isLoading = false;
  //     });
  //   }
  // }

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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
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
                onPressed: () {}, icon: const Icon(Icons.auto_awesome)),
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...sections
                            .where((section) =>
                                section != 'YouTube Resources' &&
                                careerDetails.containsKey(section))
                            .map((section) => _buildSection(
                                section, careerDetails[section]!)),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    CareerPathway(career: widget.title)));
                          },
                          child: Card(
                            elevation: 3,
                            shadowColor:
                                isDarkTheme ? Colors.grey : Colors.black,
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                child: Row(
                                  children: [
                                    const Icon(CupertinoIcons.map_fill),
                                    SizedBox(
                                      width: screenWidth * 0.04,
                                    ),
                                    const Expanded(
                                        child:
                                            Text('Tap to view career pathway!'))
                                  ],
                                )),
                          ),
                        ),
                        if (youtubeVideos.isNotEmpty) _buildYouTubeSection(),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (ctx) =>
                                    CareerDetailAiGuide(title: widget.title)));
                          },
                          child: Card(
                            elevation: 3,
                            shadowColor:
                                isDarkTheme ? Colors.grey : Colors.black,
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            child: Padding(
                                padding: EdgeInsets.all(screenWidth * 0.04),
                                child: Row(
                                  children: [
                                    const Icon(
                                        CupertinoIcons.chat_bubble_text_fill),
                                    SizedBox(
                                      width: screenWidth * 0.04,
                                    ),
                                    const Expanded(
                                        child: Text(
                                            'Still confused? Tap here to talk with Daimon!'))
                                  ],
                                )),
                          ),
                        ),
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
