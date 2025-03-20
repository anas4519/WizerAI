import 'dart:convert';

import 'package:career_counsellor/auth/auth_service.dart';
import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/ai_guidance/widgets/empty_state.dart';
import 'package:career_counsellor/pages/ai_guidance/widgets/suggestion_card.dart';
import 'package:career_counsellor/pages/ai_guidance/widgets/survey_again_button.dart';
import 'package:career_counsellor/pages/profile/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AiGuidance extends StatefulWidget {
  const AiGuidance({super.key});

  @override
  State<AiGuidance> createState() => _AiGuidanceState();
}

class _AiGuidanceState extends State<AiGuidance>
    with SingleTickerProviderStateMixin {
  final authService = AuthService();
  final SupabaseClient supabase = Supabase.instance.client;
  List<String> daimonSuggestions = [];
  List<String> urls = [];
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  final userBox = Hive.box('user_box');

  void logout() async {
    await authService.signOut();
  }

  Future<void> fetchUserDataForFirstTime(SharedPreferences prefs) async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      print(data);
      setState(() {
        // Store all available data from the profile
        for (var key in data.keys) {
          if (data[key] != null) {
            // Store in Hive
            userBox.put(key, data[key].toString());
            // Store in SharedPreferences
            prefs.setString(key, data[key].toString());
          }
        }

        daimonSuggestions = (data['suggestions'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      });

      // Store suggestions separately
      for (int i = 0; i < 5; i++) {
        prefs.setString('r_$i', daimonSuggestions[i]);
        userBox.put('r_$i', daimonSuggestions[i]);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> fetchUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getString('r_0') == null) {
      await fetchUserDataForFirstTime(prefs);
    } else {
      for (int i = 0; i < 5; i++) {
        daimonSuggestions.add(prefs.getString('r_$i') ?? 'Career');
      }
    }

    if (daimonSuggestions.isNotEmpty) await fetchImagesFromPexels();
    setState(() {
      _isLoading = false;
    });
    _animationController.forward();
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
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    fetchUserData();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          'Career Compass',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.02),
            child: Hero(
              tag: 'profileAvatar',
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (ctx) => const ProfileScreen()),
                    );
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: theme.shadowColor.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      backgroundColor: theme.primaryColor.withOpacity(0.15),
                      child: Icon(
                        Icons.person,
                        color: theme.primaryColor,
                      ),
                    ),
                  ),
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
              theme.primaryColor.withOpacity(0.1),
              theme.scaffoldBackgroundColor,
              theme.scaffoldBackgroundColor,
            ],
          ),
        ),
        child: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/ai-loader1.json',
                      width: screenWidth * 0.4,
                      height: screenWidth * 0.4,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading your career path...',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              )
            : daimonSuggestions.isEmpty
                ? EmptyState(fadeInAnimation: _fadeInAnimation)
                : _buildSuggestionsListWidget(
                    context, screenWidth, screenHeight),
      ),
    );
  }

  Widget _buildSuggestionsListWidget(
      BuildContext context, double screenWidth, double screenHeight) {
    final theme = Theme.of(context);

    return FadeTransition(
      opacity: _fadeInAnimation,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: SizedBox(height: screenHeight * 0.04)),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(screenWidth * 0.06,
                  screenHeight * 0.12, screenWidth * 0.06, screenHeight * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Hello, ',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: '${userBox.get('full_name')}',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: theme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Here are your personalized career suggestions:',
                          style: theme.textTheme.bodyLarge?.copyWith(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                // Show staggered effect for each card
                return TweenAnimationBuilder<double>(
                  tween: Tween(begin: 1.0, end: 0.0),
                  duration: Duration(milliseconds: 500 + (index * 100)),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(0, value * 50),
                      child: Opacity(
                        opacity: 1 - value,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.06,
                            screenHeight * 0.01,
                            screenWidth * 0.06,
                            screenHeight * 0.01,
                          ),
                          child: CareerSuggestionCard(
                            title: daimonSuggestions[index],
                            description: '',
                            image: urls[index],
                            cta: 'jhjbhjb',
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              childCount: daimonSuggestions.length,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
                padding: EdgeInsets.all(screenWidth * 0.06),
                child: const SurveyAgainButton()),
          ),
        ],
      ),
    );
  }
}
