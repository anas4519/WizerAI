import 'package:career_counsellor/pages/ai_guidance/screens/ai_chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:gpt_markdown/gpt_markdown.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final isLoading = message.text.trim().toLowerCase() == 'loading';

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: message.text));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Message copied!')),
        );
      },
      child: Align(
        alignment:
            message.isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: message.isUser
                ? MediaQuery.of(context).size.width * 0.7
                : double.infinity,
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: message.isUser ? Colors.pink : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 32,
                  height: 32,
                  child: SpinKitDoubleBounce(
                    color: Colors.grey,
                  ),
                )
              : GptMarkdown(
                  message.text,
                  style: TextStyle(
                    color: isDarkMode || message.isUser
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }
}
