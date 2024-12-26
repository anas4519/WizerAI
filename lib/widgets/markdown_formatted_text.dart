import 'package:flutter/material.dart';

class MarkDownFormattedText extends StatelessWidget {
  final String markdownString;

  const MarkDownFormattedText({super.key, required this.markdownString});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final lines = markdownString.split('\n');

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: lines.length,
      itemBuilder: (context, index) {
        final line = lines[index].trim();

        if (line.startsWith('##')) {
          final title = line.substring(2).trim();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        } else if (line.startsWith('**') && line.endsWith('**')) {
          // Section title
          final title = line.substring(2, line.length - 2).trim();
          return Padding(
            padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          );
        } else if (line.startsWith('*') && line.contains(':')) {
          // Subsection title with a bullet point
          final subsection = line.substring(1).trim();
          final parts = subsection.split('**');
          return Padding(
            padding: EdgeInsets.only(left: 16, top: screenHeight * 0.005),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Expanded(
                  child: SelectableText.rich(
                    TextSpan(
                        children: parts.map((part) {
                      final isBold = part == parts[1];
                      return TextSpan(
                        text: part,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight:
                              isBold ? FontWeight.bold : FontWeight.normal,
                        ),
                      );
                    }).toList()),
                  ),
                ),
              ],
            ),
          );
        } else if (line.startsWith('*')) {
          // Bullet points
          final bulletText = line.substring(1).trim();
          return Padding(
            padding: const EdgeInsets.only(left: 32.0, top: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('• ', style: TextStyle(fontSize: 16)),
                Expanded(
                  child:
                      Text(bulletText, style: const TextStyle(fontSize: 16.0)),
                ),
              ],
            ),
          );
        } else if (line.isNotEmpty) {
          // Regular text
          return Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: SelectableText(
              line,
              style: const TextStyle(fontSize: 16.0),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
