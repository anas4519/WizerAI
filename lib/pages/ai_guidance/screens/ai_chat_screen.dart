import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;

class Message {
  final String text;
  final bool isUser;
  Message({required this.text, required this.isUser});
}

class AIChatScreen extends StatefulWidget {
  const AIChatScreen({
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
    required this.prevRecommendation,
    required this.pos,
    required this.first,
    required this.second,
    required this.third,
    required this.fourth,
    required this.fifth,
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
  final String prevRecommendation;
  final String first;
  final String second;
  final String third;
  final String fourth;
  final String fifth;
  final String additionalInfo;
  final int pos;

  @override
  State<AIChatScreen> createState() => _AIChatScreenState();
}

class _AIChatScreenState extends State<AIChatScreen> {
  late genai.GenerativeModel model;
  late genai.ChatSession chat;
  final TextEditingController _messageController = TextEditingController();
  final List<Message> messages = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    model = genai.GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: GEMINI_API_KEY,
    );

    final initialContext = '''
     You are a career advisor bot. Here's the context about the user:
      Current standard: ${widget.qualifications}
      Interests: ${widget.interests}
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

      These were your recommendations : 
      1. ${widget.first}
      2. ${widget.second}
      3. ${widget.third}
      4, ${widget.fourth}
      5. ${widget.fifth}
    ''';

    chat = model.startChat(history: [
      genai.Content.text(initialContext),
    ]);

    _sendMessage(
        'Why did you recommend ${widget.prevRecommendation} at position ${widget.pos}?',
        isInitial: true);
  }

  Future<void> _sendMessage(String text, {bool isInitial = false}) async {
    if (text.isEmpty) return;

    setState(() {
      if (!isInitial) messages.add(Message(text: text, isUser: true));
      isLoading = true;
    });

    try {
      final response = await chat.sendMessage(genai.Content.text(text));
      setState(() {
        messages.add(Message(text: response.text ?? '', isUser: false));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        messages.add(Message(text: 'Error: $e', isUser: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WizerAI'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ChatBubble(message: message);
              },
            ),
          ),
          if (isLoading) const LinearProgressIndicator(),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 30, left: 16, right: 16, top: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide(color: Colors.pink),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () {
                    final text = _messageController.text;
                    _messageController.clear();
                    _sendMessage(text);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Icon(Icons.arrow_upward_rounded),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
