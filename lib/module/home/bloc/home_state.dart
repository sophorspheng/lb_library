part of 'home_bloc.dart';

enum BaseStatusEnum { initial, inprogress, failure, success, noData }

class HomeState extends Equatable {
  const HomeState._({
    this.getBookList = const [],
    this.status = BaseStatusEnum.initial,
    this.errorMessage,
    this.searchQuery = '',
    this.selectedCategory,
  });

  final List<book_model.GetBookList> getBookList;
  final BaseStatusEnum status;
  final String? errorMessage;
  final String searchQuery;
  final String? selectedCategory;

  List<book_model.GetBookList> get filteredBooks {
    final query = searchQuery.trim().toLowerCase();

    return getBookList.where((book) {
      final matchesName =
          query.isEmpty || book.title.toLowerCase().contains(query);
      final category = selectedCategory?.trim().toLowerCase();
      final matchesCategory =
          category == null ||
          category.isEmpty ||
          book.category.trim().toLowerCase() == category;
      return matchesName && matchesCategory;
    }).toList();
  }

  const HomeState.initial() : this._();

  HomeState copyWith({
    BaseStatusEnum? status,
    List<book_model.GetBookList>? getBookList,
    String? errorMessage,
    String? searchQuery,
    String? selectedCategory,
    bool clearSelectedCategory = false,
    bool clearErrorMessage = false,
  }) {
    return HomeState._(
      status: status ?? this.status,
      getBookList: getBookList ?? this.getBookList,
      errorMessage: clearErrorMessage
          ? null
          : errorMessage ?? this.errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory: clearSelectedCategory
          ? null
          : selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [
    status,
    getBookList,
    errorMessage,
    searchQuery,
    selectedCategory,
  ];
}
