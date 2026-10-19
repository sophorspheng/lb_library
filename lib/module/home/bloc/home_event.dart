part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class FetchBookList extends HomeEvent {
  const FetchBookList({this.completer});

  final Completer<void>? completer;

  @override
  List<Object> get props => [?completer];
}

final class SearchBooksByName extends HomeEvent {
  const SearchBooksByName(this.query);

  final String query;

  @override
  List<Object> get props => [query];
}

final class FilterBooksByCategory extends HomeEvent {
  const FilterBooksByCategory(this.category);

  final String? category;

  @override
  List<Object> get props => [category ?? ''];
}
