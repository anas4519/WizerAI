import 'package:career_counsellor/models/youtube.dart';
import 'package:equatable/equatable.dart';

abstract class DetailFetcherState extends Equatable {
  const DetailFetcherState();

  @override
  List<Object?> get props => [];
}

class DetailFetcherStateLoading extends DetailFetcherState {}

class DetailFetcherStateLoaded extends DetailFetcherState {
  final String imageUrl;
  final Map<String, List<String>> careerDetails;
  final List<YouTubeVideo> youtubeVideos;
  final bool hasYouTubeError;

  const DetailFetcherStateLoaded({
    required this.imageUrl,
    required this.careerDetails,
    required this.youtubeVideos,
    this.hasYouTubeError = false,
  });

  @override
  List<Object?> get props =>
      [imageUrl, careerDetails, youtubeVideos, hasYouTubeError];
}

class DetailFetcherStateError extends DetailFetcherState {
  final String message;

  const DetailFetcherStateError(this.message);

  @override
  List<Object?> get props => [message];
}
