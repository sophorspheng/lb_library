import 'package:flutter/material.dart';
import 'package:lb_library/config/theme/app_color.dart';
import 'package:lb_library/core/theme/theme_controller.dart';
import 'package:lb_library/core/utils/keyboard_utils.dart';
import 'package:lb_library/languages/generated/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;
  final FocusNode _searchFocusNode = FocusNode();

  late final List<Widget> _pages = [
    Builder(builder: (_) => _buildHomeContent()),
    const Center(child: Text('Library')),
    const Center(child: Text('Wishlist')),
    const Center(child: Text('Profile')),
  ];

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: IndexedStack(index: _selectedNavIndex, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavIndex,
        backgroundColor: colorScheme.surface,
        indicatorColor: colorScheme.secondaryContainer,
        onDestinationSelected: (index) {
          KeyboardUtils.hide();
          setState(() {
            _selectedNavIndex = index;
          });
        },
        destinations:  [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            // selectedIcon: Icon(Icons.explore_rounded),
            label: S.of(context).bookMenu,
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Wishlist',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: "Wishlist",
          ),
        ],
      ),
    );
  }

  Widget _buildHomeContent() {
    return SafeArea(
      child: CustomScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        primary: true,
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHeader(),
                const SizedBox(height: 24),
                _buildSearchBar(),
                const SizedBox(height: 28),
                _buildSectionTitle('Explore Categories'),
                const SizedBox(height: 16),
                _buildCategories(),
                const SizedBox(height: 28),
                _buildSectionTitle('Featured Books'),
                const SizedBox(height: 16),
                _buildFeaturedBooks(),
                const SizedBox(height: 28),
                _buildReadingBanner(),
                const SizedBox(height: 28),
                _buildSectionTitle('Popular Books'),
                const SizedBox(height: 16),
                ...books.map(_buildBookTile),
                const SizedBox(height: 20),
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
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Home Library',
                style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text('Discover your next favorite book'),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
        IconButton(
          onPressed: () {
            appThemeController.setThemeMode(
              appThemeController.themeMode == ThemeMode.dark
                  ? ThemeMode.light
                  : ThemeMode.dark,
            );
          },
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      focusNode: _searchFocusNode,
      textInputAction: TextInputAction.search,
      onTapOutside: (_) => KeyboardUtils.hide(),
      onSubmitted: (_) => KeyboardUtils.hide(),
      decoration: InputDecoration(
        hintText: 'Search books, authors...',
        prefixIcon: IconButton(
          tooltip: 'Focus search',
          onPressed: () => KeyboardUtils.show(_searchFocusNode),
          icon: const Icon(Icons.search_rounded),
        ),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded),
        ),
        filled: true,
        fillColor: isDark ? Colors.black26 : Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
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
          child: Text('See all', style: TextStyle(color: colorScheme.primary)),
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
        separatorBuilder: (_, __) => const SizedBox(width: 18),
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
                  category['name'] as String,
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
        separatorBuilder: (_, __) => const SizedBox(width: 14),
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
                  S.of(context).appTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Continue your reading journey today.',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
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
}
