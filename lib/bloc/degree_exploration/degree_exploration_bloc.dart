import 'package:career_counsellor/pages/degree_exploration/utils/lists.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'degree_exploration_event.dart';
import 'degree_exploration_state.dart';

class DegreeExplorationBloc
    extends Bloc<DegreeExplorationEvent, DegreeExplorationState> {
  DegreeExplorationBloc() : super(DegreeExplorationInitial()) {
    on<LoadDegrees>(_onLoadDegrees);
    on<SearchDegrees>(_onSearchDegrees);
    on<ClearSearch>(_onClearSearch);
  }

  void _onLoadDegrees(LoadDegrees event, Emitter<DegreeExplorationState> emit) {
    emit(const DegreeExplorationLoaded());
  }

  void _onSearchDegrees(
      SearchDegrees event, Emitter<DegreeExplorationState> emit) {
    final currentState = state;
    if (currentState is DegreeExplorationLoaded) {
      if (event.query.isEmpty) {
        emit(currentState.copyWith(
          isSearching: false,
          searchQuery: '',
          searchResults: [],
        ));
        return;
      }

      final searchResults = _performSearch(event.query.toLowerCase());
      emit(currentState.copyWith(
        isSearching: true,
        searchQuery: event.query,
        searchResults: searchResults,
      ));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<DegreeExplorationState> emit) {
    final currentState = state;
    if (currentState is DegreeExplorationLoaded) {
      emit(currentState.copyWith(
        isSearching: false,
        searchQuery: '',
        searchResults: [],
      ));
    }
  }

  List<String> _performSearch(String query) {
    final List<String> results = [];

    for (final category in mainList) {
      for (final level in category) {
        for (final degree in level) {
          if (degree.toLowerCase().contains(query)) {
            results.add(degree);
          }
        }
      }
    }

    return results;
  }
}
