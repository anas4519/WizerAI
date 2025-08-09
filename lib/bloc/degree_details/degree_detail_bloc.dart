import 'package:bloc/bloc.dart';
import 'package:career_counsellor/bloc/degree_details/degree_detail_state.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/repository/network_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'degree_detail_event.dart';

class DegreeDetailBloc extends Bloc<DegreeDetailEvent, DegreeDetailState> {
  final NetworkRepository repository;

  DegreeDetailBloc(this.repository) : super(DegreeDetailStateLoading()) {
    on<LoadDegreeDetail>(_onLoadDegreeDetail);
  }

  Future<void> _onLoadDegreeDetail(
      LoadDegreeDetail event, Emitter<DegreeDetailState> emit) async {
    emit(DegreeDetailStateLoading());

    try {
      final results = await Future.wait([
        repository.fetchImagesFromPexels(event.title).catchError((e) {
          if (kDebugMode) {
            print('Error fetching images: $e');
          }
          return '';
        }),
        repository
            .generateDegreeContent(event.title,
                forceRefresh: event.forceRefresh)
            .catchError((e) {
          if (kDebugMode) {
            print('Error generating content: $e');
          }
          throw e;
        }),
        repository.fetchYouTubeVideos(event.title).catchError((e) {
          if (kDebugMode) {
            print('Error fetching YouTube videos: $e');
          }
          return <YouTubeVideo>[];
        }),
      ]);

      emit(DegreeDetailStateLoaded(
        imageUrl: results[0] as String,
        careerDetails: results[1] as Map<String, List<String>>,
        youtubeVideos: results[2] as List<YouTubeVideo>,
        hasYouTubeError: (results[2] as List<YouTubeVideo>).isEmpty,
      ));
    } catch (e) {
      emit(DegreeDetailStateError('Error loading career details: $e'));
    }
  }
}
