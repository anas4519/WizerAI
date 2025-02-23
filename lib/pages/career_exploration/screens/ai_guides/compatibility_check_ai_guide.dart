import 'package:career_counsellor/constants/constants.dart';
import 'package:career_counsellor/pages/ai_guidance/screens/ai_chat_screen.dart';
import 'package:career_counsellor/widgets/chat_bubble.dart';
import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart' as genai;

class CompatibilityCheckAiGuide extends StatefulWidget {
  const CompatibilityCheckAiGuide(
      {super.key, required this.prevContext, required this.title});
  final String prevContext;
  final String title;

  @override
  State<CompatibilityCheckAiGuide> createState() =>
      _CompatibilityCheckAiGuideState();
}

class _CompatibilityCheckAiGuideState extends State<CompatibilityCheckAiGuide> {
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

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _initializeChat() async {
    model = genai.GenerativeModel(
      model: 'gemini-2.0-flash',
      apiKey: GEMINI_API_KEY,
    );

    final initialContext =
        '''You are a career advisor bot whose name is 'WizeBot' and you are here to clear the user's doubts and queries about their compatibility with ${widget.title} as a career. Here is your previous conversation: ${widget.prevContext}''';

    chat = model.startChat(history: [
      genai.Content.text(initialContext),
    ]);

    setState(() {
      messages.add(
          Message(text: 'Hello, how can I help you today?', isUser: false));
    });
  }

  Future<void> _sendMessage(String text, {bool isInitial = false}) async {
    if (text.isEmpty) return;

    setState(() {
      if (!isInitial) messages.add(Message(text: text, isUser: true));

      isLoading = true;
      messages.add(Message(text: 'Loading', isUser: false));
    });

    try {
      final response = await chat.sendMessage(genai.Content.text(text));
      setState(() {
        messages.removeLast();
        messages.add(Message(text: response.text ?? '', isUser: false));
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        messages.removeLast();
        messages.add(Message(text: 'Error: $e', isUser: false));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WizeBot'),
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
                return ChatBubble(
                  message: message,
                );
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(bottom: 30, left: 16, right: 16, top: 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    maxLines: null,
                    textCapitalization: TextCapitalization.sentences,
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
                  child: isLoading
                      ? const Icon(Icons.stop)
                      : const Icon(Icons.arrow_upward_rounded),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
