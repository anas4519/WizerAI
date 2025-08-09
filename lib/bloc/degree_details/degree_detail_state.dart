import 'package:career_counsellor/models/youtube.dart';
import 'package:equatable/equatable.dart';

abstract class DegreeDetailState extends Equatable {
  const DegreeDetailState();

  @override
  List<Object?> get props => [];
}

class DegreeDetailStateLoading extends DegreeDetailState {}

class DegreeDetailStateLoaded extends DegreeDetailState {
  final String imageUrl;
  final Map<String, List<String>> careerDetails;
  final List<YouTubeVideo> youtubeVideos;
  final bool hasYouTubeError;

  const DegreeDetailStateLoaded({
    required this.imageUrl,
    required this.careerDetails,
    required this.youtubeVideos,
    this.hasYouTubeError = false,
  });

  @override
  List<Object?> get props =>
      [imageUrl, careerDetails, youtubeVideos, hasYouTubeError];
}

class DegreeDetailStateError extends DegreeDetailState {
  final String message;

  const DegreeDetailStateError(this.message);

  @override
  List<Object?> get props => [message];
}
