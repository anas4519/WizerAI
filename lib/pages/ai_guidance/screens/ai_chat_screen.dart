import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

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
  List<ChatMessage> messages = [];
  final ChatUser currentUser = ChatUser(id: '1', firstName: 'User');
  final ChatUser botUser = ChatUser(id: '2', firstName: 'Daimon AI');
  bool isTyping = false;
  final Gemini gemini = Gemini.instance;
  List<Content> chatHistory = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 500), () {
      String initialContext = '''
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

      String initialQuestion =
          'Why did you recommend ${widget.prevRecommendation} at position ${widget.pos}?';

      // Initialize chat history with system context
      chatHistory = [
        Content(parts: [Parts(text: initialContext)], role: 'user'),
      ];

      _sendInitialMessage(initialQuestion);
    });
  }

  void _sendInitialMessage(String question) {
    ChatMessage userMessage = ChatMessage(
      user: currentUser,
      createdAt: DateTime.now(),
      text: question,
    );

    setState(() {
      messages = [userMessage, ...messages];
      isTyping = true;
    });

    // Add user message to chat history
    chatHistory.add(
      Content(parts: [Parts(text: question)], role: 'user'),
    );

    _processAIResponse();
  }

  void _sendMessage(ChatMessage chatMessage) {
    setState(() {
      messages = [chatMessage, ...messages];
      isTyping = true;
    });

    // Add user message to chat history
    chatHistory.add(
      Content(parts: [Parts(text: chatMessage.text)], role: 'user'),
    );

    _processAIResponse();
  }

  void _processAIResponse() {
    try {
      gemini.chat(chatHistory).then((value) {
        if (value?.output != null) {
          // Add AI response to chat history
          chatHistory.add(
            Content(parts: [Parts(text: value!.output!)], role: 'model'),
          );

          setState(() {
            messages = [
              ChatMessage(
                user: botUser,
                createdAt: DateTime.now(),
                text: value.output!,
              ),
              ...messages,
            ];
            isTyping = false;
          });
        }
      }).catchError((error) {
        setState(() {
          isTyping = false;
          messages = [
            ChatMessage(
              user: botUser,
              createdAt: DateTime.now(),
              text: 'Sorry, there was an error processing your message: $error',
            ),
            ...messages,
          ];
        });
      });
    } catch (e) {
      setState(() {
        isTyping = false;
        messages = [
          ChatMessage(
            user: botUser,
            createdAt: DateTime.now(),
            text: 'Sorry, there was an error processing your message: $e',
          ),
          ...messages,
        ];
      });
    }
  }

  Widget _buildTypingIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'Daimon AI is typing',
            style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Daimon AI'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (isTyping) _buildTypingIndicator(),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: screenHeight * 0.01),
              child: DashChat(
                currentUser: currentUser,
                onSend: _sendMessage,
                messages: messages,
                messageOptions: MessageOptions(
                  messageTextBuilder: (ChatMessage message,
                      ChatMessage? previousMessage, ChatMessage? nextMessage) {
                    return Text(
                      message.text,
                      style: const TextStyle(fontSize: 16),
                    );
                  },
                  showCurrentUserAvatar: true,
                  currentUserContainerColor: Colors.blue,
                  timeTextColor: Colors.blue,
                  currentUserTextColor: Colors.white,
                  // textColor: Colors.white,
                  containerColor: Theme.of(context).primaryColor,
                  onLongPressMessage: (ChatMessage message) {
                    Clipboard.setData(ClipboardData(text: message.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Message copied to clipboard!')),
                    );
                  },
                ),
                inputOptions: InputOptions(
                  inputDecoration: InputDecoration(
                    hintStyle: const TextStyle(color: Colors.grey),
                    hintText: 'Write a Message...',
                    labelStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.08),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(screenWidth * 0.08),
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                    ),
                  ),
                  sendButtonBuilder: (onSend) => IconButton(
                    icon:
                        Icon(Icons.send, color: Theme.of(context).primaryColor),
                    onPressed: onSend,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
