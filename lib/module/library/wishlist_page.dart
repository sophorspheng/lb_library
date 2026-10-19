import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/module/home/bloc/home_bloc.dart';
import 'package:lb_library/module/library/widgets/book_download_button.dart';
import 'package:lb_library/module/login/model/get_book_list.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  final TextEditingController _searchController = TextEditingController();

  String _searchQuery = '';

  // Theme-aware colors
  bool get isDark => Theme.of(context).brightness == Brightness.dark;

  Color get primaryColor => Theme.of(context).colorScheme.primary;

  Color get backgroundColor => Theme.of(context).scaffoldBackgroundColor;

  Color get cardColor => Theme.of(context).cardColor;

  Color get textColor => Theme.of(context).colorScheme.onSurface;

  Color get secondaryTextColor =>
      Theme.of(context).colorScheme.onSurfaceVariant;

  Color get subtleColor =>
      isDark ? const Color(0xFF26352D) : const Color(0xFFE3F4E9);

  // final List<Map<String, dynamic>> _books = [
  //   {
  //     'id': '1',
  //     'title': 'Flutter Development Guide',
  //     'author': 'John Smith',
  //     'category': 'Programming',
  //     'rating': 4.8,
  //     'cover': 'https://placehold.co/300x420/237A57/FFFFFF.png?text=Flutter',
  //   },
  //   {
  //     'id': '2',
  //     'title': 'Clean Code',
  //     'author': 'Robert C. Martin',
  //     'category': 'Technology',
  //     'rating': 4.9,
  //     'cover': 'https://placehold.co/300x420/263746/FFFFFF.png?text=Clean+Code',
  //   },
  //   {
  //     'id': '3',
  //     'title': 'Atomic Habits',
  //     'author': 'James Clear',
  //     'category': 'Self Development',
  //     'rating': 4.7,
  //     'cover':
  //         'https://placehold.co/300x420/D9B978/263746.png?text=Atomic+Habits',
  //   },
  //   {
  //     'id': '4',
  //     'title': 'The Psychology of Money',
  //     'author': 'Morgan Housel',
  //     'category': 'Finance',
  //     'rating': 4.8,
  //     'cover': 'https://placehold.co/300x420/526A82/FFFFFF.png?text=Money',
  //   },
  // ];

  // List<Map<String, dynamic>> get _filteredBooks {
  //   final query = _searchQuery.trim().toLowerCase();

  //   if (query.isEmpty) {
  //     return _books;
  //   }

  //   return _books.where((book) {
  //     final title = book['title'].toString().toLowerCase();
  //     final author = book['author'].toString().toLowerCase();
  //     final category = book['category'].toString().toLowerCase();

  //     return title.contains(query) ||
  //         author.contains(query) ||
  //         category.contains(query);
  //   }).toList();
  // }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // void _removeBook(Map<String, dynamic> book) {
  //   final index = _books.indexOf(book);

  //   setState(() {
  //     _books.remove(book);
  //   });

  //   ScaffoldMessenger.of(context)
  //     ..hideCurrentSnackBar()
  //     ..showSnackBar(
  //       SnackBar(
  //         content: Text('${book['title']} removed from wishlist'),
  //         behavior: SnackBarBehavior.floating,
  //         backgroundColor: isDark
  //             ? const Color(0xFF303B34)
  //             : const Color(0xFF26372E),
  //         action: SnackBarAction(
  //           label: 'UNDO',
  //           textColor: const Color(0xFF8DE0B2),
  //           onPressed: () {
  //             setState(() {
  //               _books.insert(index.clamp(0, _books.length), book);
  //             });
  //           },
  //         ),
  //       ),
  //     );
  // }

  // void _openBookDetails(Map<String, dynamic> book) {
  //   // Replace this with navigation to your BookDetailView.
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text('Open ${book['title']}'),
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) =>
          previous.getBookList != current.getBookList,
      builder: (context, state) {
        final query = _searchQuery.trim().toLowerCase();

        final favoriteBooks = state.getBookList
            .where(
              (book) =>
                  book.isFavorite &&
                  (query.isEmpty ||
                      book.title.toLowerCase().contains(query) ||
                      book.author.toLowerCase().contains(query) ||
                      book.category.toLowerCase().contains(query)),
            )
            .toList();
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: AppBar(
            backgroundColor: backgroundColor,
            elevation: 0,
            scrolledUnderElevation: 0,
            automaticallyImplyLeading: false,
            titleSpacing: 20,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'My Wishlist',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'Your favorite books in one place',
                  style: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            actions: [
              Container(
                margin: const EdgeInsets.only(right: 20),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: IconButton(
                  tooltip: 'Clear search',
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                  icon: Icon(Icons.refresh_rounded, color: primaryColor),
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search and count
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: TextStyle(color: textColor, fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search books, authors...',
                          hintStyle: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            color: secondaryTextColor,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close_rounded,
                                    color: secondaryTextColor,
                                  ),
                                )
                              : null,
                          filled: true,
                          fillColor: cardColor,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 17,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: isDark
                                  ? Colors.white.withValues(alpha: 0.05)
                                  : Colors.black.withValues(alpha: 0.03),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide(
                              color: primaryColor,
                              width: 1.3,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Text(
                            'Saved Books',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: subtleColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${favoriteBooks.length}',
                              style: TextStyle(
                                color: primaryColor,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            'BOOKS',
                            style: TextStyle(
                              color: secondaryTextColor,
                              fontSize: 10,
                              letterSpacing: 1.2,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Book list or empty state
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: context.read<HomeBloc>().refreshBookList,
                    child: favoriteBooks.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(height: 360, child: _buildEmptyState()),
                            ],
                          )
                        : ListView.separated(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                            itemCount: favoriteBooks.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 14),
                            itemBuilder: (context, index) {
                              return _buildBookCard(favoriteBooks[index]);
                            },
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookCard(GetBookList book) {
    final cover = book.coverImageUrl.trim();
    Widget coverImage;
    if (cover.startsWith('http://') || cover.startsWith('https://')) {
      coverImage = Image.network(
        cover,
        width: 100,
        height: 142,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _coverPlaceholder(),
      );
    } else {
      final commaIndex = cover.indexOf(',');
      final encoded = cover.startsWith('data:') && commaIndex >= 0
          ? cover.substring(commaIndex + 1)
          : cover;
      try {
        coverImage = cover.isEmpty
            ? _coverPlaceholder()
            : Image.memory(
                base64Decode(encoded),
                width: 100,
                height: 142,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _coverPlaceholder(),
              );
      } on FormatException {
        coverImage = _coverPlaceholder();
      }
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.06)
              : Colors.black.withValues(alpha: 0.035),
        ),
        boxShadow: isDark
            ? []
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.035),
                  blurRadius: 14,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(borderRadius: BorderRadius.circular(12), child: coverImage),
          const SizedBox(width: 14),
          Expanded(
            child: SizedBox(
              height: 142,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          book.category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.favorite_rounded,
                        color: Color(0xFFE85D75),
                        size: 22,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 15,
                      height: 1.3,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    book.author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: secondaryTextColor, fontSize: 12),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: Color(0xFFF4B740),
                        size: 18,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        book.rating.toStringAsFixed(1),
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                      BookDownloadButton(book: book),
                      const Spacer(),
                      SizedBox(
                        height: 34,
                        child: FilledButton(
                          onPressed: () => context.pushNamed(
                            AppRoute.bookViewDetail,
                            extra: book,
                          ),
                          style: FilledButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Details',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _coverPlaceholder() {
    return Container(
      width: 100,
      height: 142,
      color: subtleColor,
      alignment: Alignment.center,
      child: Icon(Icons.menu_book_rounded, size: 40, color: primaryColor),
    );
  }

  Widget _buildEmptyState() {
    final isSearching = _searchQuery.trim().isNotEmpty;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: subtleColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isSearching
                    ? Icons.search_off_rounded
                    : Icons.favorite_border_rounded,
                size: 52,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              isSearching ? 'No books found' : 'Your wishlist is empty',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              isSearching
                  ? 'Try another title, author, or category.'
                  : 'Discover interesting books and tap the heart '
                        'to save them here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            if (isSearching) ...[
              const SizedBox(height: 20),
              OutlinedButton(
                onPressed: () {
                  _searchController.clear();
                  setState(() {
                    _searchQuery = '';
                  });
                },
                child: const Text('Clear Search'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
