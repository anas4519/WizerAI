import 'package:equatable/equatable.dart';

abstract class DegreeExplorationEvent extends Equatable {
  const DegreeExplorationEvent();

  @override
  List<Object> get props => [];
}

class SearchDegrees extends DegreeExplorationEvent {
  final String query;

  const SearchDegrees(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends DegreeExplorationEvent {}

class LoadDegrees extends DegreeExplorationEvent {}
