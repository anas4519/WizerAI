import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:career_counsellor/widgets/markdown_formatted_text.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

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
      model: 'gemini-1.5-flash',
      apiKey: GEMINI_API_KEY,
    );

    final prompt = 'Step by step career pathway for a student in 12th grade living in India if they want to become a ${widget.career}.';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Pathway'),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : MarkDownFormattedText(markdownString: body)
    );
  }
}
