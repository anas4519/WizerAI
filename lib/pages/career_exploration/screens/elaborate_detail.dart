import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/utils/utils.dart';
import 'package:career_counsellor/widgets/markdown_formatted_text.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as google_ai;

class ElaborateDetail extends StatefulWidget {
  const ElaborateDetail({
    super.key,
    required this.title,
    required this.career,
  });

  final String title;
  final String career;

  @override
  State<ElaborateDetail> createState() => _ElaborateDetailState();
}

class _ElaborateDetailState extends State<ElaborateDetail> {
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

    final prompt =
        'Elaborate on the ${widget.title} of ${widget.career} as a career.';

    final content = [google_ai.Content.text(prompt)];
    try {
      final result = await model.generateContent(content);
      setState(() {
        if (result.text != null) {
          String response = result.text!;
          body = response;
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
          title: Text(widget.title),
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
