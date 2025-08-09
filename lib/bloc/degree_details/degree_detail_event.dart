part of 'degree_detail_bloc.dart';

abstract class DegreeDetailEvent extends Equatable {
  const DegreeDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadDegreeDetail extends DegreeDetailEvent {
  final String title;
  final bool forceRefresh;

  const LoadDegreeDetail(this.title, {this.forceRefresh = false});

  @override
  List<Object?> get props => [title, forceRefresh];
}
