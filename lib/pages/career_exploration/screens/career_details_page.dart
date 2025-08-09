import 'package:career_counsellor/bloc/bloc/detail_fetcher_bloc.dart';
import 'package:career_counsellor/bloc/bloc/detail_fetcher_state.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/animated_fade_in.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/career_pathway_card.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/chat_with_bot.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/compatibility_check_button.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/cons_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/default_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/pros_section.dart';
import 'package:career_counsellor/pages/career_exploration/widgets/youtube_section.dart';
import 'package:career_counsellor/repository/network_repository.dart';
import 'package:career_counsellor/widgets/info_container.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class CareerDetailsPage extends StatefulWidget {
  const CareerDetailsPage({super.key, required this.title});
  final String title;

  @override
  State<CareerDetailsPage> createState() => _CareerDetailsPageState();
}

class _CareerDetailsPageState extends State<CareerDetailsPage> {
  final List<String> sections = [
    'Overview',
    'Education Required in India',
    'Best Schools in India',
    'Work Environment',
    'Salaries in India',
    'Pros',
    'Cons',
    'Industry Trends',
    'YouTube Resources'
  ];

  Widget _buildSection(String title, List<String> content,
      List<YouTubeVideo> youtubeVideos, bool hasYouTubeError) {
    if (content.isEmpty && title != 'YouTube Resources') {
      return const SizedBox.shrink();
    }

    if (title == 'YouTube Resources') {
      if (hasYouTubeError) {
        return YoutubeSection(
          errMsg:
              'Unable to show YouTube videos at this moment. Please try again later!',
        );
      }

      return youtubeVideos.isNotEmpty
          ? YoutubeSection(youtubeVideos: youtubeVideos)
          : const SizedBox.shrink();
    }

    if (title == 'Pros') {
      return ProsSection(title: title, content: content, career: widget.title);
    }
    if (title == 'Cons') {
      return ConsSection(title: title, content: content, career: widget.title);
    }
    return DefaultSection(title: title, content: content, career: widget.title);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final themeData = Theme.of(context);
    final isDarkTheme = themeData.brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => DetailFetcherBloc(NetworkRepository())
        ..add(LoadDetailFetcher(widget.title)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isDarkTheme ? Colors.white : Colors.pink,
            ),
          ),
          centerTitle: true,
          elevation: 2,
          actions: [
            BlocBuilder<DetailFetcherBloc, DetailFetcherState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () {
                    context
                        .read<DetailFetcherBloc>()
                        .add(RefreshDetailFetcher(widget.title));
                  },
                  tooltip: 'Refresh data',
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<DetailFetcherBloc, DetailFetcherState>(
          builder: (context, state) {
            if (state is DetailFetcherStateLoading) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      'assets/animations/ai-loader1.json',
                      width: screenWidth * 0.3,
                      height: screenWidth * 0.3,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Text(
                        'Analyzing ${widget.title}...',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: isDarkTheme ? Colors.white70 : Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (state is DetailFetcherStateError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Could not load career information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDarkTheme ? Colors.white : Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDarkTheme ? Colors.white70 : Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          context
                              .read<DetailFetcherBloc>()
                              .add(LoadDetailFetcher(widget.title));
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Try Again'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            if (state is DetailFetcherStateLoaded) {
              return RefreshIndicator(
                onRefresh: () async {
                  context
                      .read<DetailFetcherBloc>()
                      .add(RefreshDetailFetcher(widget.title));
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (state.imageUrl.isNotEmpty)
                        AnimatedFadeIn(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            margin: const EdgeInsets.only(bottom: 24),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: FancyShimmerImage(
                                imageUrl: state.imageUrl,
                                errorWidget: Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image_not_supported,
                                      size: 50),
                                ),
                                width: screenWidth,
                                height: screenHeight * 0.25,
                                boxFit: BoxFit.cover,
                                shimmerBackColor: Colors.grey[300]!,
                                shimmerBaseColor: Colors.grey[200]!,
                                shimmerHighlightColor: Colors.white,
                              ),
                            ),
                          ),
                        ),

                      // Content sections
                      ...sections
                          .where((section) =>
                              section != 'YouTube Resources' &&
                              state.careerDetails.containsKey(section) &&
                              (state.careerDetails[section]?.isNotEmpty ??
                                  false))
                          .map((section) => AnimatedFadeIn(
                                delay: Duration(
                                    milliseconds:
                                        100 * sections.indexOf(section)),
                                child: _buildSection(
                                    section,
                                    state.careerDetails[section]!,
                                    state.youtubeVideos,
                                    state.hasYouTubeError),
                              )),

                      // Additional cards
                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 500),
                        child: CareerPathwayCard(title: widget.title),
                      ),

                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 600),
                        child: _buildSection('YouTube Resources', [],
                            state.youtubeVideos, state.hasYouTubeError),
                      ),

                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 700),
                        child: CompatibilityCheckCard(title: widget.title),
                      ),

                      AnimatedFadeIn(
                        delay: const Duration(milliseconds: 800),
                        child: ChatWithBot(title: widget.title),
                      ),

                      SizedBox(height: screenHeight * 0.02),

                      // Disclaimer
                      const InfoContainer(
                        text:
                            'This content is generated by AI and may sometimes contain inaccuracies or incomplete information. Please verify independently when necessary.',
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
