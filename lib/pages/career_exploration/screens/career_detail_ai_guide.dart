import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gemini/flutter_gemini.dart';

class CareerDetailAiGuide extends StatefulWidget {
  const CareerDetailAiGuide({super.key, required this.title});
  final String title;

  @override
  State<CareerDetailAiGuide> createState() => _CareerDetailAiGuideState();
}

class _CareerDetailAiGuideState extends State<CareerDetailAiGuide> {
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
      You are a career advisor bot and you are here to clear the user's doubts and queries about ${widget.title} as a career''';
      chatHistory = [
        Content(parts: [Parts(text: initialContext)], role: 'user'),
      ];
      _sendInitialMessage();
    });
  }

  @override
  void dispose() {
    messages.clear();
    chatHistory.clear();
    super.dispose();
  }

  void _sendInitialMessage() {
    ChatMessage initialMessage = ChatMessage(
      user: botUser,
      createdAt: DateTime.now(),
      text: 'Hello there! How can I help you today?',
    );

    setState(() {
      messages = [initialMessage, ...messages];
    });
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
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
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
                  currentUserContainerColor: isDarkTheme?Colors.blue:Colors.blue.shade300,
                  timeTextColor: Colors.blue,
                  // currentUserTextColor: Colors.white,
                  // textColor: Colors.white,
                  containerColor: isDarkTheme?Colors.pink:Colors.pink.shade200,
                  onLongPressMessage: (ChatMessage message) {
                    Clipboard.setData(ClipboardData(text: message.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Message copied to clipboard!')),
                    );
                  },
                ),
                inputOptions: InputOptions(
                  textCapitalization: TextCapitalization.sentences,
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
