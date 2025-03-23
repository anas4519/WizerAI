import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:career_counsellor/widgets/info_container.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:hive_ce/hive.dart';
import 'package:lottie/lottie.dart';

class CareerPathway extends StatefulWidget {
  const CareerPathway({
    super.key,
    required this.career,
  });

  final String career;

  @override
  State<CareerPathway> createState() => _CareerPathwayState();
}

class _CareerPathwayState extends State<CareerPathway> {
  bool isLoading = true;
  String? errorMessage;
  String body = '';
  final userBox = Hive.box('user_box');

  @override
  void initState() {
    super.initState();
    _generateContent();
  }

  Future<void> _generateContent() async {
    setState(() {
      isLoading = true;
    });
    final model = google_ai.GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: GEMINI_API_KEY,
    );

    final prompt =
        'Step by step career pathway for a student with the following qualifiacations : "${userBox.get('qualifications')}", living in India if they want to become a ${widget.career}.';

    final content = [google_ai.Content.text(prompt)];
    try {
      final result = await model.generateContent(content);
      setState(() {
        if (result.text != null) {
          String recommendations = result.text!;
          body = recommendations;
        }
        isLoading = false;
      });
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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Career Pathway'),
          centerTitle: true,
        ),
        body: isLoading
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
                : SingleChildScrollView(
                    padding: EdgeInsets.all(screenWidth * 0.04),
                    child: Column(
                      children: [
                        GptMarkdown(
                          body,
                          style: const TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: screenWidth * 0.1,
                        ),
                        const InfoContainer(
                            text:
                                'This content is generated by AI and may sometimes contain inaccuracies or incomplete information. Please verify independently when necessary.')
                      ],
                    ),
                  ));
    // MarkDownFormattedText(markdownString: body));
  }
}
