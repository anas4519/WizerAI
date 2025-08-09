part of 'detail_fetcher_bloc.dart';

abstract class DetailFetcherEvent extends Equatable {
  const DetailFetcherEvent();

  @override
  List<Object?> get props => [];
}

class LoadDetailFetcher extends DetailFetcherEvent {
  final String title;
  final bool forceRefresh;

  const LoadDetailFetcher(this.title, {this.forceRefresh = false});

  @override
  List<Object?> get props => [title, forceRefresh];
}

class RefreshDetailFetcher extends DetailFetcherEvent {
  final String title;

  const RefreshDetailFetcher(this.title);

  @override
  List<Object?> get props => [title];
}
