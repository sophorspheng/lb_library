import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lb_library/config/theme/app_color.dart';
import 'package:lb_library/core/storage/preferences_service.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:lb_library/core/utils/keyboard_utils.dart';
import 'package:lb_library/home/service/home_service.dart';
import 'package:lb_library/languages/generated/l10n.dart';
import 'package:lb_library/module/library/library_page.dart';
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

  final List<Map<String, dynamic>> books = [
    {
      'title': 'The Alchemist',
      'author': 'Paulo Coelho',
      'icon': Icons.auto_stories,
      'color': Color(0xFFD9B47A),
    },
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'icon': Icons.psychology_rounded,
      'color': Color(0xFF91B5A1),
    },
    {
      'title': 'Rich Dad Poor Dad',
      'author': 'Robert Kiyosaki',
      'icon': Icons.account_balance_rounded,
      'color': Color(0xFFE3A18D),
    },
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
  }

  Widget _buildHomeContent() {
    return SafeArea(
      bottom: false,
      child: CustomScrollView(
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
            title: _buildSearchBar(),
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
                ...books.map(_buildBookTile),
              ]),
            ),
          ),
        ],
      ),
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

  Widget _buildSearchBar() {
    final colorScheme = Theme.of(context).colorScheme;

    return TextField(
      focusNode: _searchFocusNode,
      textInputAction: TextInputAction.search,
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

    return SizedBox(
      height: 105,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 18),
        itemBuilder: (context, index) {
          final category = categories[index];

          return SizedBox(
            width: 75,
            child: Column(
              children: [
                Container(
                  height: 58,
                  width: 58,
                  decoration: BoxDecoration(
                    color: colorScheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: colorScheme.primary,
                    size: 27,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  _categoryName(category['name'] as String),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildFeaturedBooks() {
    final colorScheme = Theme.of(context).colorScheme;

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
              onTap: () => _openBook(book),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: book['color'] as Color,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        book['icon'] as IconData,
                        size: 65,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    book['title'] as String,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    book['author'] as String,
                    maxLines: 1,
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

  Widget _buildBookTile(Map<String, dynamic> book) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(10),
        leading: Container(
          height: 60,
          width: 55,
          decoration: BoxDecoration(
            color: book['color'] as Color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(book['icon'] as IconData, color: Colors.white),
        ),
        title: Text(
          book['title'] as String,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(book['author'] as String),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
          onPressed: () => _openBook(book),
        ),
        onTap: () => _openBook(book),
      ),
    );
  }

  void _openBook(Map<String, dynamic> book) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Selected: ${book['title']}'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _categoryName(String category) {
    final localizations = S.of(context);
    return switch (category) {
      'Fiction' => localizations.fiction,
      'Education' => localizations.education,
      'History' => localizations.history,
      'Science' => localizations.science,
      _ => category,
    };
  }

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
