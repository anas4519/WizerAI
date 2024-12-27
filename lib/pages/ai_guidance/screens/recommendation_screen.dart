import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/ai_chat_screen.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:career_counsellor/widgets/info_container.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;
import 'package:supabase_flutter/supabase_flutter.dart';

class RecommendationScreen extends StatefulWidget {
  const RecommendationScreen({
    super.key,
    required this.qualifications,
    required this.interests,
    required this.hobbies,
    required this.skills,
    required this.strengths,
    required this.weaknesses,
    required this.desiredLifestyle,
    required this.geographicPref,
    required this.aspirations,
    required this.learningCurve,
    required this.mothersProfession,
    required this.fathersProfession,
    required this.parentsExpectations,
    required this.interdisciplinaryOptions,
    required this.financialStatus,
    required this.salaryExpectations,
    required this.additionalInfo,
  });

  final String qualifications;
  final String interests;
  final String hobbies;
  final String skills;
  final String strengths;
  final String weaknesses;
  final String desiredLifestyle;
  final String geographicPref;
  final String aspirations;
  final String learningCurve;
  final String mothersProfession;
  final String fathersProfession;
  final String parentsExpectations;
  final String interdisciplinaryOptions;
  final String financialStatus;
  final String salaryExpectations;
  final String additionalInfo;

  @override
  State<RecommendationScreen> createState() => _RecommendationScreenState();
}

class _RecommendationScreenState extends State<RecommendationScreen> {
  bool isLoading = true;
  List<String> recommendationsList = [];
  final SupabaseClient supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();
    _generateInitialRecommendations();
    _saveDetails();
  }

  Future<void> _saveDetails() async {
    final userId = supabase.auth.currentUser!.id;
    final updateData = {
      'qualifications': widget.qualifications,
      'interests': widget.interests,
      'hobbies': widget.hobbies,
      'strengths': widget.strengths,
      'desired_lifestyle': widget.desiredLifestyle,
      'learning_curve': widget.learningCurve,
      'mothers_profession': widget.mothersProfession,
      'fathers_profession': widget.fathersProfession,
      'financial_status': widget.financialStatus,
      'salary_expectations': widget.salaryExpectations,
    };

    if (widget.skills.isNotEmpty) {
      updateData['skills'] = widget.skills;
    }
    if (widget.weaknesses.isNotEmpty) {
      updateData['weaknesses'] = widget.weaknesses;
    }
    if (widget.geographicPref.isNotEmpty) {
      updateData['geographic_preferences'] = widget.geographicPref;
    }
    if (widget.aspirations.isNotEmpty) {
      updateData['aspirations'] = widget.aspirations;
    }
    if (widget.parentsExpectations.isNotEmpty) {
      updateData['parents_expectations'] = widget.parentsExpectations;
    }
    if (widget.interdisciplinaryOptions.isNotEmpty) {
      updateData['interdisciplinary_options'] = widget.interdisciplinaryOptions;
    }
    if (widget.additionalInfo.isNotEmpty) {
      updateData['additional_info'] = widget.additionalInfo;
    }

    await supabase.from('profiles').update(updateData).eq('id', userId);
  }

  Future<void> _updateSuggestions() async {
    final userId = supabase.auth.currentUser!.id;

    try {
      await supabase.from('profiles').update({
        'suggestions': recommendationsList, // Update the suggestions column
      }).eq('id', userId);
    } catch (e) {
      showSnackBar(context, 'Error updating suggestions: $e');
    }
  }

  Future<void> _generateInitialRecommendations() async {
    setState(() {
      isLoading = true;
    });
    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );

    final prompt = '''
    This student needs help finding a suitable career. Help him find top 5 careers for him/her, based on the following information, along with market trends. I need you to rank the 5 careers. Do not write anything else, just the 5 suggested careers.
    Current standard : ${widget.qualifications}
    Interests: ${widget.interests}
    Hobbies: ${widget.hobbies}
    Skills: ${widget.skills}
    Strengths: ${widget.strengths}
    Weaknesses: ${widget.weaknesses}
    Desired Lifestyle: ${widget.desiredLifestyle}
    Geographic Preferences: ${widget.geographicPref}
    Aspirations: ${widget.aspirations}
    Learning Curve: ${widget.learningCurve}
    Mother's Profession: ${widget.mothersProfession}
    Father's Profession: ${widget.fathersProfession}
    Parents' expectations: ${widget.parentsExpectations}
    Interdisciplinary Options: ${widget.interdisciplinaryOptions}
    Current Financial Status: ${widget.financialStatus}
    Salary Expectations: ${widget.salaryExpectations}
    Additional Information: ${widget.additionalInfo}
    ''';

    final content = [google_ai.Content.text(prompt)];
    try {
      final result = await model.generateContent(content);
      setState(() {
        if (result.text != null) {
          String recommendations = result.text!;
          recommendationsList = recommendations
              .split('\n')
              .where((line) => line.trim().isNotEmpty)
              .map((line) => line.replaceAll(RegExp(r'^\d+\.\s*'), '').trim())
              .toList();
        }
        isLoading = false;
      });
      await _updateSuggestions();
    } catch (e) {
      setState(() {
        showSnackBar(context, 'Error: $e');
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('DAI Suggestions'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: isLoading ? null : _generateInitialRecommendations,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: isLoading
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Generating recommendations...'),
                    ],
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Based on the details you\'ve provided, the AI suggests the following career options:\n',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(
                      height: screenHeight * 0.6,
                      child: ListView.builder(
                        itemCount: recommendationsList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.01),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Theme.of(context).primaryColor,
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                recommendationsList[index],
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),
                              ),
                              trailing: IconButton(
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => AIChatScreen(
                                            qualifications:
                                                widget.qualifications,
                                            interests: widget.interests,
                                            hobbies: widget.hobbies,
                                            skills: widget.skills,
                                            strengths: widget.strengths,
                                            weaknesses: widget.weaknesses,
                                            desiredLifestyle:
                                                widget.desiredLifestyle,
                                            geographicPref:
                                                widget.geographicPref,
                                            aspirations: widget.aspirations,
                                            learningCurve: widget.learningCurve,
                                            mothersProfession:
                                                widget.mothersProfession,
                                            fathersProfession:
                                                widget.fathersProfession,
                                            parentsExpectations:
                                                widget.parentsExpectations,
                                            interdisciplinaryOptions:
                                                widget.interdisciplinaryOptions,
                                            financialStatus:
                                                widget.financialStatus,
                                            salaryExpectations:
                                                widget.salaryExpectations,
                                            prevRecommendation:
                                                recommendationsList[index],
                                            pos: index + 1,
                                            first: recommendationsList[0],
                                            second: recommendationsList[1],
                                            third: recommendationsList[2],
                                            fourth: recommendationsList[3],
                                            fifth: recommendationsList[4],
                                            additionalInfo:
                                                widget.additionalInfo,
                                          )));
                                },
                                icon: const Icon(Icons.arrow_forward_ios),
                                color: Theme.of(context).primaryColor,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.03,
                                vertical: screenWidth * 0.03,
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const InfoContainer(
                        text:
                            'Tap arrow icons to discuss careers with Daimon AI'),
                    SizedBox(height: screenHeight * 0.02),
                    const Text(
                      'Note: These suggestions are AI-generated. Please conduct your own research or consult career counselors before making decisions.',
                      style: TextStyle(fontSize: 12),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                        icon: const Icon(Icons.home_filled),
                        label: const Text('Go back to Home'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Center(
                      child: ElevatedButton.icon(
                        onPressed:
                            isLoading ? null : _generateInitialRecommendations,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Generate Again'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
