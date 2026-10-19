import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lb_library/config/routes/app_route.dart';
import 'package:lb_library/config/theme/app_color.dart';
import 'package:lb_library/core/storage/preferences_service.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:lb_library/core/utils/keyboard_utils.dart';
import 'package:lb_library/module/home/bloc/home_bloc.dart';
import 'package:lb_library/languages/generated/l10n.dart';
import 'package:lb_library/module/library/library_page.dart';
import 'package:lb_library/module/library/widgets/book_download_button.dart';
import 'package:lb_library/module/library/wishlist_page.dart';
import 'package:lb_library/module/setting/setting_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();

  final List<Map<String, dynamic>> categories = [
    {'name': 'Fiction', 'icon': Icons.auto_stories_rounded},
    {'name': 'Education', 'icon': Icons.school_rounded},
    {'name': 'History', 'icon': Icons.history_edu_rounded},
    {'name': 'Science', 'icon': Icons.science_rounded},
  ];

  static const Color primaryColor = Color(0xFF176B48);

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      Builder(builder: (_) => _buildHomeContent()),
      LibraryPage(),
      WishlistPage(),
      SettingsPage(),
    ];

    return BlocProvider(
      create: (context) => HomeBloc()..add(FetchBookList()),
      child: BlocBuilder<HomeBloc, HomeState>(
        buildWhen: (previous, current) =>
            previous.status != current.status ||
            previous.getBookList != current.getBookList,
        builder: (context, state) {
          return Scaffold(
            body: IndexedStack(index: _selectedNavIndex, children: pages),
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedNavIndex,
              backgroundColor: Theme.of(context).colorScheme.surface,
              indicatorColor: Theme.of(context).colorScheme.secondaryContainer,
              elevation: 0,
              labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
              onDestinationSelected: (index) {
                KeyboardUtils.hide();
                setState(() {
                  _selectedNavIndex = index;
                });
              },
              destinations: [
                NavigationDestination(
                  icon: const Icon(Icons.home_outlined),
                  selectedIcon: const Icon(Icons.home_rounded),
                  label: S.of(context).home,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.menu_book_outlined),
                  selectedIcon: const Icon(Icons.menu_book_rounded),
                  label: S.of(context).books,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.favorite_border_rounded),
                  selectedIcon: const Icon(Icons.favorite_rounded),
                  label: S.of(context).favorites,
                ),
                NavigationDestination(
                  icon: const Icon(Icons.person_outline_rounded),
                  selectedIcon: const Icon(Icons.person_rounded),
                  label: S.of(context).profile,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHomeContent() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) =>
          p.getBookList != c.getBookList || p.searchQuery != c.searchQuery,
      builder: (context, state) {
        return SafeArea(
          bottom: false,
          child: RefreshIndicator(
            onRefresh: context.read<HomeBloc>().refreshBookList,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                // Brand header scrolls away
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                    child: _buildHeader(),
                  ),
                ),

                SliverAppBar(
                  pinned: true,
                  floating: false,
                  automaticallyImplyLeading: false,
                  // backgroundColor: colorScheme.surface,
                  surfaceTintColor: Colors.transparent,
                  elevation: 0,
                  scrolledUnderElevation: 0,
                  toolbarHeight: 78,
                  titleSpacing: 20,
                  title: _buildSearchBar(context),
                ),

                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      _buildSectionTitle(S.of(context).exploreCategories),
                      const SizedBox(height: 16),
                      _buildCategories(),

                      const SizedBox(height: 28),

                      _buildSectionTitle(S.of(context).featuredBooks),
                      const SizedBox(height: 16),
                      _buildFeaturedBooks(),

                      const SizedBox(height: 28),

                      _buildReadingBanner(),

                      const SizedBox(height: 28),

                      _buildSectionTitle(S.of(context).popularBooks),
                      const SizedBox(height: 12),
                      _buildBookTile(),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            color: primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.menu_book_rounded,
            color: Colors.white,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                S.of(context).hometitle,
                style: const TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(S.of(context).discoverBooks),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          onPressed: _toggleTheme,
          icon: Icon(
            appThemeController.themeMode == ThemeMode.dark
                ? Icons.brightness_2
                : Icons.brightness_2_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      focusNode: _searchFocusNode,
      textInputAction: TextInputAction.search,
      onChanged: (query) =>
          context.read<HomeBloc>().add(SearchBooksByName(query)),
      onTapOutside: (_) => KeyboardUtils.hide(),
      onSubmitted: (_) => KeyboardUtils.hide(),
      decoration: InputDecoration(
        hintText: S.of(context).searchBooksAuthors,
        hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          tooltip: S.of(context).filterBooks,
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded),
        ),
        filled: true,
        // fillColor: colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(
            color: colorScheme.primary.withValues(alpha: 0.5),
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: Text(
            S.of(context).seeAll,
            style: TextStyle(color: colorScheme.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildCategories() {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) =>
          p.selectedCategory != c.selectedCategory ||
          p.getBookList != c.getBookList,
      builder: (context, state) {
        final categoryNames =
            state.getBookList
                .map((book) => book.category.trim())
                .where((category) => category.isNotEmpty)
                .toSet()
                .toList()
              ..sort();

        return SizedBox(
          height: 105,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: categoryNames.length,
            separatorBuilder: (_, _) => const SizedBox(width: 18),
            itemBuilder: (context, index) {
              final categoryName = categoryNames[index];
              final isSelected = state.selectedCategory == categoryName;
              final matchingCategory = categories.where(
                (category) =>
                    (category['name'] as String).toLowerCase() ==
                    categoryName.toLowerCase(),
              );
              final icon = matchingCategory.isEmpty
                  ? Icons.category_rounded
                  : matchingCategory.first['icon'] as IconData;

              return SizedBox(
                width: 75,
                child: InkWell(
                  borderRadius: BorderRadius.circular(18),
                  onTap: () => context.read<HomeBloc>().add(
                    FilterBooksByCategory(isSelected ? null : categoryName),
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 58,
                        width: 58,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? colorScheme.primary
                              : colorScheme.secondaryContainer,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Icon(
                          icon,
                          color: isSelected
                              ? colorScheme.onPrimary
                              : colorScheme.primary,
                          size: 27,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        categoryName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildFeaturedBooks() {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) =>
          p.status != c.status ||
          p.getBookList != c.getBookList ||
          p.searchQuery != c.searchQuery ||
          p.selectedCategory != c.selectedCategory ||
          p.errorMessage != c.errorMessage,
      builder: (context, state) {
        if (state.status == BaseStatusEnum.inprogress) {
          return const SizedBox(
            height: 230,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.status == BaseStatusEnum.failure) {
          return SizedBox(
            height: 230,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    state.errorMessage ?? 'Could not load books.',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () =>
                        context.read<HomeBloc>().add(const FetchBookList()),
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state.status == BaseStatusEnum.noData) {
          return const SizedBox(
            height: 230,
            child: Center(child: Text('No books available yet.')),
          );
        }

        final books = state.filteredBooks;
        if (books.isEmpty) {
          return const SizedBox(
            height: 230,
            child: Center(child: Text('No books match your search.')),
          );
        }

        return SizedBox(
          height: 230,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: books.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final book = books[index];

              return SizedBox(
                width: 145,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16),
                  onTap: () =>
                      context.pushNamed(AppRoute.bookViewDetail, extra: book),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colorScheme.secondaryContainer,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: _buildBookCover(book.coverImageUrl),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              book.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BookDownloadButton(book: book),
                        ],
                      ),
                      Text(
                        book.author,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReadingBanner() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColor.active,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  S.of(context).continueReading,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  S.of(context).continueReadingJourney,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          const Icon(Icons.menu_book_rounded, color: Colors.white, size: 48),
        ],
      ),
    );
  }

  Widget _buildBookTile() {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (p, c) => p.getBookList != c.getBookList,
      // p.searchQuery != c.searchQuery ||
      // p.selectedCategory != c.selectedCategory,
      builder: (context, state) {
        final favoriteBooks = state.filteredBooks
            .where((book) => book.isFavorite)
            .toList();
        // if (favoriteBooks.isEmpty) return const SizedBox.shrink();

        return Column(
          children: favoriteBooks.map((book) {
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: SizedBox(
                  height: 72,
                  width: 55,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: _buildBookCover(book.coverImageUrl),
                  ),
                ),
                title: Text(
                  book.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  book.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BookDownloadButton(book: book),
                    const Icon(Icons.arrow_forward_ios_rounded, size: 18),
                  ],
                ),
                onTap: () =>
                    context.pushNamed(AppRoute.bookViewDetail, extra: book),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _buildBookCover(String coverImage) {
    final source = coverImage.trim();
    if (source.isEmpty) return _bookCoverPlaceholder();

    if (source.startsWith('https://') || source.startsWith('http://')) {
      return Image.network(
        source,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _bookCoverPlaceholder(),
      );
    }

    final commaIndex = source.indexOf(',');
    final base64Source = source.startsWith('data:') && commaIndex >= 0
        ? source.substring(commaIndex + 1)
        : source;
    try {
      return Image.memory(
        base64Decode(base64Source),
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _bookCoverPlaceholder(),
      );
    } on FormatException {
      return _bookCoverPlaceholder();
    }
  }

  Widget _bookCoverPlaceholder() =>
      const Center(child: Icon(Icons.menu_book_rounded, size: 40));

  // String _categoryName(String category) {
  //   final localizations = S.of(context);
  //   return switch (category) {
  //     'Fiction' => localizations.fiction,
  //     'Education' => localizations.education,
  //     'History' => localizations.history,
  //     'Science' => localizations.science,
  //     _ => category,
  //   };
  // }

  Future<void> _toggleTheme() async {
    final nextMode = appThemeController.themeMode == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    try {
      await appThemeController.setThemeMode(nextMode);
    } on PlatformException catch (error) {
      _showPreferenceError(error);
    } on MissingPluginException catch (error) {
      _showPreferenceError(error);
    } on PreferencesException catch (error) {
      _showPreferenceError(error);
    }
  }

  void _showPreferenceError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Could not save app preference: $error')),
    );
  }
}
