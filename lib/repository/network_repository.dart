import 'dart:convert';
import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;
import 'package:hive_ce/hive.dart';
import 'package:http/http.dart' as http;

class NetworkRepository {
  final _aiCache = Hive.box('ai_cache');

  Future<String> fetchImagesFromPexels(String query) async {
    const apiKey = PEXELS_API_KEY;
    const perPage = 1;
    try {
      final url = Uri.parse(
          'https://api.pexels.com/v1/search?query=$query&per_page=$perPage');
      final response = await http.get(url, headers: {'Authorization': apiKey});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final photos = data['photos'] as List<dynamic>;
        if (photos.isNotEmpty) {
          return photos[0]['src']['landscape'];
        }
      } else {
        if (kDebugMode) {
          print(
              'Error for query "$query": ${response.statusCode} - ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception fetching image: $e');
      }
    }
    return '';
  }

  Future<List<YouTubeVideo>> fetchYouTubeVideos(String title) async {
    final String apiKey = Constants.YOUTUBE_aPI_KEY;
    try {
      final String searchQuery = 'How to become a $title in India';
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
        final data = json.decode(response.body);
        final items = data['items'] as List;
        return items.map((item) {
          final snippet = item['snippet'];
          return YouTubeVideo(
            title: snippet['title'],
            url: 'https://www.youtube.com/watch?v=${item['id']['videoId']}',
            thumbnailUrl: snippet['thumbnails']['high']['url'],
            channelTitle: snippet['channelTitle'],
          );
        }).toList();
      } else {
        throw Exception(
            'Failed to fetch YouTube videos: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching YouTube videos: ${e.toString()}');
      }
      throw Exception('Error fetching YouTube videos: $e');
    }
  }

  bool _isDataExpired(DateTime storedDate) {
    final now = DateTime.now();
    return now.difference(storedDate).inDays >= 10;
  }

  Future<Map<String, List<String>>> generateCareerContent(String title,
      {bool forceRefresh = false}) async {
    final cacheKey = 'career_${title.toLowerCase().replaceAll(' ', '_')}';

    if (!forceRefresh && _aiCache.containsKey(cacheKey)) {
      final cachedData = _aiCache.get(cacheKey);
      final timestamp = cachedData[1] as DateTime;

      if (!_isDataExpired(timestamp)) {
        return _parseDetails(cachedData[0] as String);
      }
    }

    final model = google_ai.GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: GEMINI_API_KEY,
    );

    String prompt = '''
You are a professional career counselor specializing in Indian careers and education. 
Generate comprehensive, accurate, and up-to-date information about the '$title' career path in India.

Focus on providing factual, well-researched information with practical insights relevant to students and job seekers in India.

Return ONLY a valid JSON object with the following structure:
{
  "Overview": [
    "Detailed description of what the $title profession entails",
    "Key responsibilities and daily activities",
    "Types of organizations and industries employing ${title}s",
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

Each point should be a complete, informative sentence with specific details about the '$title' career in India.
Do not include any explanations, notes, or text outside the JSON structure.
Ensure the JSON is valid with properly escaped characters.
''';

    final content = [google_ai.Content.text(prompt)];
    var modelResult = await model.generateContent(content);
    String response = modelResult.text?.trim() ?? '';

    if (response.contains("```json")) {
      response = response.substring(response.indexOf("```json") + 7);
    } else if (response.startsWith("```")) {
      response = response.substring(3);
    }
    if (response.contains("```")) {
      response = response.substring(0, response.lastIndexOf("```"));
    }
    response = response.trim();

    _aiCache.put(cacheKey, [response, DateTime.now()]);
    return _parseDetails(response);
  }

  Map<String, List<String>> _parseDetails(String jsonString) {
    try {
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      return jsonData.map((key, value) {
        if (value is List) {
          return MapEntry(key, value.map((item) => item.toString()).toList());
        }
        return MapEntry(key, <String>[]);
      });
    } catch (jsonError) {
      if (kDebugMode) {
        print("JSON parsing error: $jsonError");
        print("Attempted to parse: $jsonString");
      }
      return _parseMalformedResponse(jsonString);
    }
  }

  Map<String, List<String>> _parseMalformedResponse(String response) {
    Map<String, List<String>> parsedSections = {};
    String currentSection = '';
    List<String> currentPoints = [];

    List<String> lines = response.split('\n');

    for (String line in lines) {
      line = line.trim();
      if (line.isEmpty) continue;

      if (line.startsWith('"') && line.contains('":')) {
        if (currentSection.isNotEmpty && currentPoints.isNotEmpty) {
          parsedSections[currentSection] = List<String>.from(currentPoints);
          currentPoints = [];
        }
        currentSection = line.split('":')[0].replaceAll('"', '').trim();
      } else if (line.startsWith(RegExp(r'[A-Z]')) && line.endsWith(':')) {
        if (currentSection.isNotEmpty && currentPoints.isNotEmpty) {
          parsedSections[currentSection] = List<String>.from(currentPoints);
          currentPoints = [];
        }
        currentSection = line.replaceAll(':', '').trim();
      } else if (line.contains("[") && !line.contains("]")) {
        currentSection =
            line.split("[")[0].replaceAll('"', '').replaceAll(':', '').trim();
        currentPoints = [];
      } else if (line.startsWith(RegExp(r'[\-\*\•]')) ||
          line.startsWith(RegExp(r'\d+\.'))) {
        String cleanedLine =
            line.replaceAll(RegExp(r'[\-\*\•\d+\.]'), '').trim();
        if (cleanedLine.isNotEmpty && currentSection.isNotEmpty) {
          cleanedLine =
              cleanedLine.replaceAll(RegExp(r'^"|"$|^"|"$'), '').trim();
          cleanedLine = cleanedLine.replaceAll(RegExp(r"^'|'$"), '').trim();
          if (cleanedLine.endsWith(',')) {
            cleanedLine = cleanedLine.substring(0, cleanedLine.length - 1);
          }
          currentPoints.add(cleanedLine);
        }
      } else if (line.contains('"') && line.endsWith(',')) {
        String cleanedLine = line.replaceAll(RegExp(r'^"|"$|^"|"$'), '').trim();
        cleanedLine = cleanedLine.replaceAll(',', '').trim();
        if (cleanedLine.isNotEmpty && currentSection.isNotEmpty) {
          currentPoints.add(cleanedLine);
        }
      }
    }

    if (currentSection.isNotEmpty && currentPoints.isNotEmpty) {
      parsedSections[currentSection] = List<String>.from(currentPoints);
    }

    return parsedSections;
  }

  Future<Map<String, List<String>>> generateDegreeContent(String title,
      {bool forceRefresh = false}) async {
    final cacheKey = 'career_${title.toLowerCase().replaceAll(' ', '_')}';

    if (!forceRefresh && _aiCache.containsKey(cacheKey)) {
      final cachedData = _aiCache.get(cacheKey);
      final timestamp = cachedData[1] as DateTime;

      if (!_isDataExpired(timestamp)) {
        return _parseDetails(cachedData[0] as String);
      }
    }

    final model = google_ai.GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: GEMINI_API_KEY,
    );

    String prompt = '''
You are a professional career counselor specializing in Indian education and higher studies. 
Generate comprehensive, accurate, and up-to-date information about the '$title' degree program in India.

Focus on providing factual, well-researched information with practical insights relevant to students, parents, and academic advisors in India.

Return ONLY a valid JSON object with the following structure:
{
  "Overview": [
    "Detailed description of what the $title degree is about",
    "Core focus areas and learning objectives",
    "Relevance and importance of this degree in India",
    "Typical academic approach and teaching methods"
  ],
  "Eligibility & Admission in India": [
    "Minimum educational qualifications for admission",
    "Entrance exams commonly required for this degree",
    "Typical cut-off percentages or ranks",
    "Reservation policies and category-specific relaxations",
    "Alternative entry routes (lateral entry, distance learning, etc.)"
  ],
  "Course Structure & Duration": [
    "Total duration of the program in years/semesters",
    "Major subjects and core courses covered",
    "Elective or specialization options available",
    "Practical training, labs, or internships included",
    "Industry projects or capstone requirements"
  ],
  "Best Colleges in India": [
    "Top institutions offering this degree",
    "Notable programs with high placement records",
    "Institutions with strong industry tie-ups",
    "Colleges offering scholarships or financial aid",
    "Best faculty and infrastructure for this program"
  ],
  "Skills Developed": [
    "Technical or subject-specific skills gained",
    "Soft skills and transferable skills acquired",
    "Research and analytical abilities",
    "Creative or problem-solving skills relevant to the field",
    "Skills that improve employability in India"
  ],
  "Career Opportunities in India": [
    "Common job roles after completing the degree",
    "Industries and sectors hiring graduates",
    "Opportunities for self-employment or entrepreneurship",
    "Government sector roles available",
    "Career progression paths"
  ],
  "Higher Studies & Certifications": [
    "Relevant master's or doctoral programs",
    "Professional certifications that complement the degree",
    "International study opportunities",
    "Specialized diplomas or short courses after graduation",
    "Pathways for academic research"
  ],
  "Salary Expectations in India": [
    "Entry-level salary ranges in rupees",
    "Mid-career salary potential",
    "Salary variations by specialization",
    "Impact of institution reputation on salaries",
    "Comparison with related degrees"
  ],
  "Pros": [
    "Key advantages of pursuing this degree",
    "Career growth potential",
    "Opportunities for skill development",
    "Relevance in the current job market",
    "Long-term benefits"
  ],
  "Cons": [
    "Common challenges faced by students",
    "Academic or workload pressures",
    "Cost considerations",
    "Market saturation in certain specializations",
    "Barriers to entry in top institutions"
  ],
  "Industry & Academic Trends": [
    "Emerging specializations in this field",
    "Technological changes impacting the curriculum",
    "Shifts in demand for this degree in India",
    "Changes in teaching methodologies",
    "Global trends influencing Indian education in this field"
  ]
}

Each point should be a complete, informative sentence with specific details about the '$title' degree in India.
Do not include any explanations, notes, or text outside the JSON structure.
Ensure the JSON is valid with properly escaped characters.
''';

    final content = [google_ai.Content.text(prompt)];
    var modelResult = await model.generateContent(content);
    String response = modelResult.text?.trim() ?? '';

    if (response.contains("```json")) {
      response = response.substring(response.indexOf("```json") + 7);
    } else if (response.startsWith("```")) {
      response = response.substring(3);
    }
    if (response.contains("```")) {
      response = response.substring(0, response.lastIndexOf("```"));
    }
    response = response.trim();

    _aiCache.put(cacheKey, [response, DateTime.now()]);
    return _parseDetails(response);
  }
}
