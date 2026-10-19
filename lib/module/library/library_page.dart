import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/module/home/bloc/home_bloc.dart';
import 'package:lb_library/module/library/widgets/book_download_button.dart';
import 'package:lb_library/module/login/model/get_book_list.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCategory = 'All';
  String _selectedFilter = 'All Books';
  String _selectedSort = 'Title';
  bool _isGridView = false;

  static const _filters = ['All Books', 'Favorites', 'Active', 'Inactive'];
  static const _sortOptions = ['Title', 'Author', 'Highest rated'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state.status == BaseStatusEnum.inprogress &&
            state.getBookList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.status == BaseStatusEnum.failure &&
            state.getBookList.isEmpty) {
          return _buildMessage(
            context,
            icon: Icons.cloud_off_rounded,
            title: 'Could not load your library',
            message: state.errorMessage ?? 'Please try again.',
            action: TextButton.icon(
              onPressed: () =>
                  context.read<HomeBloc>().add(const FetchBookList()),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Retry'),
            ),
          );
        }

        if (state.getBookList.isEmpty) {
          return _buildMessage(
            context,
            icon: Icons.menu_book_rounded,
            title: 'Your library is empty',
            message: 'There are no books available yet.',
            action: state.status == BaseStatusEnum.failure
                ? TextButton.icon(
                    onPressed: () =>
                        context.read<HomeBloc>().add(const FetchBookList()),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  )
                : null,
          );
        }

        return _buildLibrary(
          context,
          state.getBookList,
          errorMessage: state.status == BaseStatusEnum.failure
              ? state.errorMessage
              : null,
        );
      },
    );
  }

  Widget _buildLibrary(
    BuildContext context,
    List<GetBookList> allBooks, {
    String? errorMessage,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final categories = _categoriesFor(allBooks);
    final selectedCategory = categories.contains(_selectedCategory)
        ? _selectedCategory
        : 'All';
    final books = _filterAndSortBooks(
      allBooks,
      selectedCategory: selectedCategory,
    );

    return RefreshIndicator(
      onRefresh: _refreshBooks,
      child: SafeArea(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'My Library',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: -0.7,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Your personal world of books',
                            style: TextStyle(
                              color: colorScheme.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: 'Sort books',
                      onPressed: _showSortOptions,
                      icon: const Icon(Icons.sort_rounded),
                    ),
                    const SizedBox(width: 8),
                    IconButton.filledTonal(
                      tooltip: 'Refresh books',
                      onPressed: _refreshBooks,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ],
                ),
              ),
            ),
            if (errorMessage != null && errorMessage.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Material(
                    color: colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                    child: ListTile(
                      leading: Icon(
                        Icons.warning_amber_rounded,
                        color: colorScheme.onErrorContainer,
                      ),
                      title: Text(
                        errorMessage,
                        style: TextStyle(color: colorScheme.onErrorContainer),
                      ),
                      trailing: IconButton(
                        tooltip: 'Retry loading books',
                        onPressed: _refreshBooks,
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              sliver: SliverToBoxAdapter(
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: 'Search books, authors, or categories...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Clear search',
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                    filled: true,
                    fillColor: colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverToBoxAdapter(child: _buildSummaryCard(allBooks)),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 26, 20, 12),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Categories',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      '${books.length} ${books.length == 1 ? 'book' : 'books'}',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 44,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final selected = category == selectedCategory;
                    return ChoiceChip(
                      label: Text(category),
                      selected: selected,
                      onSelected: (_) =>
                          setState(() => _selectedCategory = category),
                      selectedColor: colorScheme.primary,
                      backgroundColor: colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(
                        color: selected
                            ? colorScheme.onPrimary
                            : colorScheme.onSurface,
                        fontWeight: selected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      side: BorderSide.none,
                      showCheckmark: false,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    );
                  },
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
              sliver: SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _selectedFilter,
                        style: const TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    PopupMenuButton<String>(
                      initialValue: _selectedFilter,
                      tooltip: 'Filter books',
                      onSelected: (value) =>
                          setState(() => _selectedFilter = value),
                      itemBuilder: (_) => _filters
                          .map(
                            (filter) => PopupMenuItem<String>(
                              value: filter,
                              child: Text(filter),
                            ),
                          )
                          .toList(),
                      child: _menuButton(
                        context,
                        label: _selectedFilter,
                        icon: Icons.filter_list_rounded,
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      tooltip: _isGridView ? 'List view' : 'Grid view',
                      onPressed: () =>
                          setState(() => _isGridView = !_isGridView),
                      icon: Icon(
                        _isGridView
                            ? Icons.view_list_rounded
                            : Icons.grid_view_rounded,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (books.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 44,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No books found',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Try another search, category, or filter.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else if (_isGridView)
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildGridBook(context, books[index]),
                    childCount: books.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 260,
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildListBook(context, books[index]),
                    ),
                    childCount: books.length,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<String> _categoriesFor(List<GetBookList> books) {
    final categories =
        books
            .map((book) => book.category.trim())
            .where((category) => category.isNotEmpty)
            .toSet()
            .toList()
          ..sort();
    return ['All', ...categories];
  }

  List<GetBookList> _filterAndSortBooks(
    List<GetBookList> allBooks, {
    required String selectedCategory,
  }) {
    final query = _searchController.text.trim().toLowerCase();
    final books = allBooks.where((book) {
      final matchesSearch =
          query.isEmpty ||
          book.title.toLowerCase().contains(query) ||
          book.author.toLowerCase().contains(query) ||
          book.category.toLowerCase().contains(query);
      final matchesCategory =
          selectedCategory == 'All' ||
          book.category.trim().toLowerCase() ==
              selectedCategory.trim().toLowerCase();
      final matchesFilter = switch (_selectedFilter) {
        'Favorites' => book.isFavorite,
        'Active' => book.isActive,
        'Inactive' => !book.isActive,
        _ => true,
      };
      return matchesSearch && matchesCategory && matchesFilter;
    }).toList();

    switch (_selectedSort) {
      case 'Author':
        books.sort(
          (a, b) => a.author.toLowerCase().compareTo(b.author.toLowerCase()),
        );
      case 'Highest rated':
        books.sort((a, b) => b.rating.compareTo(a.rating));
      default:
        books.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
    }
    return books;
  }

  Future<void> _refreshBooks() async {
    await context.read<HomeBloc>().refreshBookList();
  }

  Widget _buildSummaryCard(List<GetBookList> books) {
    final favorites = books.where((book) => book.isFavorite).length;
    final active = books.where((book) => book.isActive).length;
    final favoriteRatio = books.isEmpty ? 0.0 : favorites / books.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF176B48), Color(0xFF32966B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Your book collection',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            '${books.length} ${books.length == 1 ? 'Book' : 'Books'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 18,
            runSpacing: 8,
            children: [
              _summaryItem(
                Icons.check_circle_outline_rounded,
                '$active Active',
              ),
              _summaryItem(Icons.favorite_rounded, '$favorites Favorites'),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: favoriteRatio,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${(favoriteRatio * 100).round()}% marked as favorites',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(IconData icon, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.white, size: 18),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  Widget _buildListBook(BuildContext context, GetBookList book) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openBook(context, book),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              _buildCover(book, width: 76, height: 104),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.category,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: Color(0xFFFFB300),
                        ),
                        const SizedBox(width: 4),
                        Text(book.rating.toStringAsFixed(1)),
                        const SizedBox(width: 12),
                        Text(
                          '${book.pageCount} pages',
                          style: TextStyle(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              BookDownloadButton(book: book),
              if (book.isFavorite)
                Icon(Icons.favorite_rounded, color: colorScheme.error)
              else
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridBook(BuildContext context, GetBookList book) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => _openBook(context, book),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Center(
                  child: _buildCover(
                    book,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                book.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                book.author,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    size: 16,
                    color: Color(0xFFFFB300),
                  ),
                  const SizedBox(width: 3),
                  Text(book.rating.toStringAsFixed(1)),
                  const Spacer(),
                  BookDownloadButton(book: book),
                  if (book.isFavorite)
                    Icon(
                      Icons.favorite_rounded,
                      size: 17,
                      color: colorScheme.error,
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(
    GetBookList book, {
    required double width,
    required double height,
  }) {
    final source = book.coverImageUrl.trim();
    Widget cover;
    if (source.startsWith('http://') || source.startsWith('https://')) {
      cover = Image.network(
        source,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _coverPlaceholder(),
      );
    } else {
      final commaIndex = source.indexOf(',');
      final encoded = source.startsWith('data:') && commaIndex >= 0
          ? source.substring(commaIndex + 1)
          : source;
      try {
        cover = source.isEmpty
            ? _coverPlaceholder()
            : Image.memory(
                base64Decode(encoded),
                width: width,
                height: height,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _coverPlaceholder(),
              );
      } on FormatException {
        cover = _coverPlaceholder();
      }
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(width: width, height: height, child: cover),
    );
  }

  Widget _coverPlaceholder() => Container(
    color: Theme.of(context).colorScheme.secondaryContainer,
    alignment: Alignment.center,
    child: Icon(
      Icons.menu_book_rounded,
      size: 36,
      color: Theme.of(context).colorScheme.primary,
    ),
  );

  Widget _menuButton(
    BuildContext context, {
    required String label,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 17),
          const SizedBox(width: 5),
          Text(label, style: const TextStyle(fontSize: 12)),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
        ],
      ),
    );
  }

  Widget _buildMessage(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String message,
    Widget? action,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 48, color: colorScheme.primary),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 6),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
              if (action != null) ...[const SizedBox(height: 12), action],
            ],
          ),
        ),
      ),
    );
  }

  void _openBook(BuildContext context, GetBookList book) {
    context.pushNamed(AppRoute.bookViewDetail, extra: book);
  }

  void _showSortOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort books',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ..._sortOptions.map(
                  (option) => ListTile(
                    title: Text(option),
                    trailing: _selectedSort == option
                        ? const Icon(
                            Icons.check_rounded,
                            color: Color(0xFF176B48),
                          )
                        : null,
                    onTap: () {
                      setState(() => _selectedSort = option);
                      Navigator.pop(sheetContext);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
