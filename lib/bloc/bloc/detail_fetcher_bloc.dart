import 'package:bloc/bloc.dart';
import 'package:career_counsellor/bloc/bloc/detail_fetcher_state.dart';
import 'package:career_counsellor/models/youtube.dart';
import 'package:career_counsellor/repository/network_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

part 'detail_fetcher_event.dart';

class DetailFetcherBloc extends Bloc<DetailFetcherEvent, DetailFetcherState> {
  final NetworkRepository repository;

  DetailFetcherBloc(this.repository) : super(DetailFetcherStateLoading()) {
    on<LoadDetailFetcher>(_onLoadDetailFetcher);
    on<RefreshDetailFetcher>(_onRefreshDetailFetcher);
  }

  Future<void> _onLoadDetailFetcher(
      LoadDetailFetcher event, Emitter<DetailFetcherState> emit) async {
    emit(DetailFetcherStateLoading());

    try {
      final results = await Future.wait([
        repository.fetchImagesFromPexels(event.title).catchError((e) {
          if (kDebugMode) {
            print('Error fetching images: $e');
          }
          return '';
        }),
        repository
            .generateContent(event.title, forceRefresh: event.forceRefresh)
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

      emit(DetailFetcherStateLoaded(
        imageUrl: results[0] as String,
        careerDetails: results[1] as Map<String, List<String>>,
        youtubeVideos: results[2] as List<YouTubeVideo>,
        hasYouTubeError: (results[2] as List<YouTubeVideo>).isEmpty,
      ));
    } catch (e) {
      emit(DetailFetcherStateError('Error loading career details: $e'));
    }
  }

  Future<void> _onRefreshDetailFetcher(
      RefreshDetailFetcher event, Emitter<DetailFetcherState> emit) async {
    emit(DetailFetcherStateLoading());

    try {
      final results = await Future.wait([
        repository.fetchImagesFromPexels(event.title).catchError((e) {
          if (kDebugMode) {
            print('Error fetching images: $e');
          }
          return '';
        }),
        repository
            .generateContent(event.title, forceRefresh: true)
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

      emit(DetailFetcherStateLoaded(
        imageUrl: results[0] as String,
        careerDetails: results[1] as Map<String, List<String>>,
        youtubeVideos: results[2] as List<YouTubeVideo>,
        hasYouTubeError: (results[2] as List<YouTubeVideo>).isEmpty,
      ));
    } catch (e) {
      emit(DetailFetcherStateError('Error loading career details: $e'));
    }
  }
}
