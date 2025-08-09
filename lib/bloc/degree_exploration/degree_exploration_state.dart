import 'package:equatable/equatable.dart';

abstract class DegreeExplorationState extends Equatable {
  const DegreeExplorationState();

  @override
  List<Object> get props => [];
}

class DegreeExplorationInitial extends DegreeExplorationState {}

class DegreeExplorationLoaded extends DegreeExplorationState {
  final bool isSearching;
  final String searchQuery;
  final List<String> searchResults;

  const DegreeExplorationLoaded({
    this.isSearching = false,
    this.searchQuery = '',
    this.searchResults = const [],
  });

  @override
  List<Object> get props => [isSearching, searchQuery, searchResults];

  DegreeExplorationLoaded copyWith({
    bool? isSearching,
    String? searchQuery,
    List<String>? searchResults,
  }) {
    return DegreeExplorationLoaded(
      isSearching: isSearching ?? this.isSearching,
      searchQuery: searchQuery ?? this.searchQuery,
      searchResults: searchResults ?? this.searchResults,
    );
  }
}
