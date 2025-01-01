import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/career_exploration/screens/ai_guides/compatibility_check_ai_guide.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:career_counsellor/widgets/markdown_formatted_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

class CompatibilityCheck extends StatefulWidget {
  const CompatibilityCheck({super.key, required this.career});
  final String career;

  @override
  State<CompatibilityCheck> createState() => _CompatibilityCheckState();
}

class _CompatibilityCheckState extends State<CompatibilityCheck> {
  final SupabaseClient supabase = Supabase.instance.client;
  bool _isLoading = true;
  String? errorMessage;
  String body = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final userId = supabase.auth.currentUser!.id;
      final data =
          await supabase.from('profiles').select().eq('id', userId).single();
      await checkCompatibility(data);
    } catch (e) {
      print('Error fetching user data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> checkCompatibility(Map<String, dynamic> data) async {
    final model = google_ai.GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );

    final prompt = '''
    You are a career advisor bot. Given below are the details of a student. Check the compatibility of the student with the career ${widget.career} and suggest the student if the career is suitable for them. Respond in first person.
    Current standard: '${data['qualifications']}', year of study: ${data['Current Year']}
    Interests: ${data['interests']}
    Hobbies: ${data['hobbies']}
    Skills: ${data['skills']}
    Strengths: ${data['strengths']}
    Weaknesses: ${data['weaknesses']}
    Desired Lifestyle: ${data['desired_ifestyle']}
    Geographic Preferences: ${data['geographic_preferences']}
    Aspirations: ${data['aspirations']}
    Learning Curve: ${data['learning_curve']}
    Mother's Profession: ${data['mothers_profession']}
    Father's Profession: ${data['fathers_profession']}
    Parents' expectations: ${data['parents_expectations']}
    Interdisciplinary Options: ${data['interdisciplinary_options']}
    Current Financial Status: ${data['financial_status']}
    Salary Expectations: ${data['salary_expectations']}
    Additional Information: ${data['additional_info']}
    ''';
    final content = [google_ai.Content.text(prompt)];
    try {
      final result = await model.generateContent(content);
      setState(() {
        if (result.text != null) {
          String response = result.text!;
          body = response;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        showSnackBar(context, 'Error: $e');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Compatibility Check'),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => CompatibilityCheckAiGuide(
                        title: widget.career,
                        prevContext: body,
                      )));
            },
            child: Lottie.asset(
              'assets/animations/bot_animation.json',
            )),
        body: _isLoading
            ? Center(
                child: Lottie.asset(
                  'assets/animations/ai-loader1.json',
                  width: screenWidth * 0.25,
                  height: screenWidth * 0.25,
                  fit: BoxFit.contain,
                ),
              )
            : errorMessage != null
                ? Center(
                    child: Text(
                      errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : MarkDownFormattedText(markdownString: body));
  }
}
