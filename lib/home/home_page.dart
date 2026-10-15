import 'package:flutter/material.dart';
import 'package:lb_library/config/theme/app_color.dart';
import 'package:lb_library/languages/generated/l10n.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedNavIndex = 0;

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
  static const Color backgroundColor = Color(0xFFF5F7F2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
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
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedNavIndex,
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFDCEDE0),
        onDestinationSelected: (index) {
          setState(() => _selectedNavIndex = index);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore_rounded),
            label: 'Discover',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark_rounded),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profile',
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
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF173C2B),
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Discover your next favorite book',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none_rounded),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search books, authors...',
        prefixIcon: const Icon(Icons.search_rounded),
        suffixIcon: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.tune_rounded),
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF173C2B),
            ),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('See all', style: TextStyle(color: primaryColor)),
        ),
      ],
    );
  }

  Widget _buildCategories() {
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
                    color: const Color(0xFFDCEDE0),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Icon(
                    category['icon'] as IconData,
                    color: primaryColor,
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
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
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
      color: Colors.white,
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
