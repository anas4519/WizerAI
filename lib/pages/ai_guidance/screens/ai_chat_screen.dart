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
  final ScrollController _scrollController = ScrollController();
  final List<Message> messages = [];
  bool isLoading = false;
  bool isSending = false;

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
      isSending = true;
      messages.add(Message(text: 'Loading', isUser: false));
    });

    _scrollToBottom();

    try {
      final response = await chat.sendMessage(genai.Content.text(text));
      setState(() {
        messages.removeLast();
        messages.add(Message(text: response.text ?? '', isUser: false));
        isSending = false;
      });
      _scrollToBottom();
    } catch (e) {
      setState(() {
        isSending = false;
        messages.removeLast();
        messages.add(Message(
            text: 'Sorry, I encountered an error. Please try again.',
            isUser: false));
      });
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.smart_toy_outlined),
            SizedBox(width: 8),
            Text('WizeBot', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset Conversation'),
                  content: const Text(
                      'Are you sure you want to start a new conversation?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('CANCEL'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          messages.clear();
                        });
                        _initializeChat();
                      },
                      child: const Text('RESET'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat history
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[900] : Colors.grey[100],
              ),
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return ChatBubble(
                          message: message,
                        );
                      },
                    ),
            ),
          ),

          // Input area
          Container(
            decoration: BoxDecoration(
              color: isDarkMode ? Colors.grey[850] : Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, -1),
                ),
              ],
            ),
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 12, bottom: 24),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color:
                            isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
                      ),
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            maxLines: 5,
                            minLines: 1,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: const InputDecoration(
                              hintText: 'Ask about career advice...',
                              border: InputBorder.none,
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 14),
                            ),
                            onSubmitted: (value) {
                              if (!isSending && value.isNotEmpty) {
                                final text = _messageController.text;
                                _messageController.clear();
                                _sendMessage(text);
                              }
                            },
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attach_file_outlined),
                          onPressed: () {
                            // Implement file attachment functionality
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('File attachments coming soon!'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  elevation: 2,
                  shape: const CircleBorder(),
                  color: Theme.of(context).primaryColor,
                  child: InkWell(
                    onTap: () {
                      if (!isSending && _messageController.text.isNotEmpty) {
                        final text = _messageController.text;
                        _messageController.clear();
                        _sendMessage(text);
                      }
                    },
                    customBorder: const CircleBorder(),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: isSending
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ))
                            : const Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
