import 'dart:convert';

import 'package:career_counsellor/auth/auth_service.dart';
import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/select_education.dart';
import 'package:career_counsellor/pages/ai_guidance/widgets/suggestion_card.dart';
import 'package:career_counsellor/pages/career_exploration/screens/career_details.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiGuidance extends StatefulWidget {
  const AiGuidance({super.key});

  @override
  State<AiGuidance> createState() => _AiGuidanceState();
}

class _AiGuidanceState extends State<AiGuidance> {
  final authService = AuthService();
  final SupabaseClient supabase = Supabase.instance.client;
  List<String> daimonSuggestions = [];
  List<String> urls = [];
  bool _isLoading = true;
  String name = 'User';

  void logout() async {
    await authService.signOut();
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    name = supabase.auth.currentUser!.email!;
    for (int i = 0; i < 5; i++) {
      daimonSuggestions.add(prefs.getString('r_$i') ?? 'Career');
    }
    if (daimonSuggestions.isNotEmpty) await fetchImagesFromPexels();
    setState(() {
      _isLoading = false;
    });
    // try {
    //   final userId = supabase.auth.currentUser!.id;
    //   final data =
    //       await supabase.from('profiles').select().eq('id', userId).single();

    //   setState(() {
    //     name = data['full_name'] ?? 'User';
    //     daimonSuggestions = data['suggestions'] != null
    //         ? (data['suggestions'] as List<dynamic>)
    //             .map((e) => e.toString())
    //             .toList()
    //         : _getDefaultSuggestions();
    //     _isLoading = false;
    //   });
    // } catch (e) {
    //   print('Error fetching user data: $e');
    //   setState(() {
    //     name = 'User';
    //     daimonSuggestions = _getDefaultSuggestions();
    //     _isLoading = false;
    //   });
    // }
  }

  Future<void> fetchImagesFromPexels() async {
    const apiKey = PEXELS_API_KEY;
    const perPage = 1;

    try {
      final futures = daimonSuggestions.map((query) async {
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
          print(photos);

          if (photos.isNotEmpty) {
            return photos[0]['src']['landscape'];
          }
        } else {
          print(
              'Error for query "$query": ${response.statusCode} - ${response.body}');
        }
        return null;
      }).toList();

      final results = await Future.wait(futures);

      // Add non-null URLs to the list
      for (final url in results) {
        urls.add(url ?? 'XYZ');
      }
    } catch (e) {
      print('Exception: $e');
    }
  }

  @override
  void initState() {
    fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home', style: theme.textTheme.titleLarge),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: Lottie.asset(
                'assets/animations/ai-loader1.json',
                width: screenWidth * 0.25,
                height: screenWidth * 0.25,
                fit: BoxFit.contain,
              ),
            )
          : daimonSuggestions.isEmpty
              ? _buildEmptyStateWidget(context)
              : _buildSuggestionsListWidget(context, screenWidth, screenHeight),
    );
  }

  Widget _buildEmptyStateWidget(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/graphics/student-graphic.png',
              width: MediaQuery.of(context).size.width * 0.75,
              height: MediaQuery.of(context).size.width * 0.75,
              fit: BoxFit.contain,
            ),
            Text(
              'Hello $name!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Discover your ideal career path by taking our survey today!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) => const SelectEducation()),
                );
              },
              icon: const Icon(CupertinoIcons.arrow_right),
              label: const Text('Take Career Survey'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 24.0),
                textStyle: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsListWidget(
      BuildContext context, double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          spacing: screenHeight * 0.0025,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi $name, here are your career suggestions:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: screenHeight * 0.02),
            for (int index = 0; index < daimonSuggestions.length; index++)
              CareerSuggestionCard(
                  title: daimonSuggestions[index],
                  description:
                      'bitchhhhhssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssh',
                  image: urls[index],
                  cta: 'jhjbhjb'),
            Center(
              child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => const SelectEducation()),
                    );
                  },
                  child: const Text('Take the survey again?')),
            )
          ],
        ),
      ),
    );
  }
}
