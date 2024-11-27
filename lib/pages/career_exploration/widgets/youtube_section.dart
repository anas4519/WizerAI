import 'package:cached_network_image/cached_network_image.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/pages/career_exploration/screens/video_player.dart';
import 'package:flutter/material.dart';

class YoutubeSection extends StatelessWidget {
  const YoutubeSection({super.key, required this.youtubeVideos});
  final List<YouTubeVideo> youtubeVideos;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shadowColor: isDarkTheme ? Colors.grey : Colors.black,
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'YouTube Videos',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.pink,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            ...youtubeVideos.map((video) => Padding(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (ctx) => VideoApp(video: video)));
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius:
                              BorderRadius.circular(screenWidth * 0.02),
                          child: CachedNetworkImage(
                            width: screenWidth * 0.3,
                            height: screenHeight * 0.08,
                            fit: BoxFit.cover,
                            imageUrl: video.thumbnailUrl,
                            placeholder: (context, url) =>
                                const Icon(Icons.play_arrow_rounded),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.play_arrow_rounded),
                          ),
                          // child: Image.network(
                          //   video.thumbnailUrl,
                          //   width: 120,
                          //   height: 68,
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                video.title,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                video.channelTitle,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
