
import 'package:flutter/material.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  static const Color primaryColor = Color(0xFF176B48);

  final TextEditingController _searchController =
      TextEditingController();

  String _selectedCategory = 'All';
  String _selectedFilter = 'All Books';
  bool _isGridView = false;

  final List<Map<String, dynamic>> _books = [
    {
      'title': 'The Alchemist',
      'author': 'Paulo Coelho',
      'category': 'Fiction',
      'color': const Color(0xFFD9B47A),
      'icon': Icons.auto_stories_rounded,
      'progress': 0.65,
      'status': 'Reading',
    },
    {
      'title': 'Atomic Habits',
      'author': 'James Clear',
      'category': 'Education',
      'color': const Color(0xFF79A88B),
      'icon': Icons.psychology_rounded,
      'progress': 0.30,
      'status': 'Reading',
    },
    {
      'title': 'Rich Dad Poor Dad',
      'author': 'Robert Kiyosaki',
      'category': 'Finance',
      'color': const Color(0xFFE3A18D),
      'icon': Icons.account_balance_rounded,
      'progress': 0.0,
      'status': 'Unread',
    },
    {
      'title': 'A Brief History of Time',
      'author': 'Stephen Hawking',
      'category': 'Science',
      'color': const Color(0xFF8499C7),
      'icon': Icons.science_rounded,
      'progress': 1.0,
      'status': 'Completed',
    },
    {
      'title': 'Think and Grow Rich',
      'author': 'Napoleon Hill',
      'category': 'Finance',
      'color': const Color(0xFFB79ACD),
      'icon': Icons.lightbulb_outline_rounded,
      'progress': 0.0,
      'status': 'Unread',
    },
    {
      'title': 'The Power of Habit',
      'author': 'Charles Duhigg',
      'category': 'Education',
      'color': const Color(0xFFCC9878),
      'icon': Icons.menu_book_rounded,
      'progress': 0.0,
      'status': 'Unread',
    },
  ];

  final List<String> _categories = [
    'All',
    'Fiction',
    'Education',
    'Finance',
    'Science',
  ];

  final List<String> _filters = [
    'All Books',
    'Reading',
    'Unread',
    'Completed',
  ];

  List<Map<String, dynamic>> get _filteredBooks {
    final query = _searchController.text.trim().toLowerCase();

    return _books.where((book) {
      final matchesSearch =
          book['title'].toString().toLowerCase().contains(query) ||
          book['author'].toString().toLowerCase().contains(query);

      final matchesCategory = _selectedCategory == 'All' ||
          book['category'] == _selectedCategory;

      final matchesStatus = _selectedFilter == 'All Books' ||
          book['status'] == _selectedFilter;

      return matchesSearch && matchesCategory && matchesStatus;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final books = _filteredBooks;

    return SafeArea(
      child: CustomScrollView(
        keyboardDismissBehavior:
            ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: [
          // Header
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
                  Container(
                    decoration: BoxDecoration(
                      color: colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: IconButton(
                      tooltip: 'Sort books',
                      onPressed: _showSortOptions,
                      icon: Icon(
                        Icons.sort_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Search
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
            sliver: SliverToBoxAdapter(
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search your books...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: _searchController.text.isEmpty
                      ? null
                      : IconButton(
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

          // Summary card
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverToBoxAdapter(
              child: _buildSummaryCard(),
            ),
          ),

          // Category heading
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
                    '${books.length} books',
                    style: TextStyle(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Category chips
          SliverToBoxAdapter(
            child: SizedBox(
              height: 44,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final category = _categories[index];
                  final selected = category == _selectedCategory;

                  return ChoiceChip(
                    label: Text(category),
                    selected: selected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = category);
                    },
                    selectedColor: colorScheme.primary,
                    backgroundColor:
                        colorScheme.surfaceContainerHighest,
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

          // Filter and view toggle
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 14),
            sliver: SliverToBoxAdapter(
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'All Books',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  PopupMenuButton<String>(
                    initialValue: _selectedFilter,
                    tooltip: 'Filter by status',
                    onSelected: (value) {
                      setState(() => _selectedFilter = value);
                    },
                    itemBuilder: (_) => _filters
                        .map(
                          (filter) => PopupMenuItem<String>(
                            value: filter,
                            child: Text(filter),
                          ),
                        )
                        .toList(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Text(
                            _selectedFilter,
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 4),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: _isGridView ? 'List view' : 'Grid view',
                    onPressed: () {
                      setState(() => _isGridView = !_isGridView);
                    },
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

          // Book list / grid
          if (books.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.menu_book_rounded,
                      size: 56,
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
                      'Try another search or category.',
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else if (_isGridView)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 30),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _buildGridBook(books[index]),
                  childCount: books.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
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
                    child: _buildListBook(books[index]),
                  ),
                  childCount: books.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final total = _books.length;
    final reading =
        _books.where((book) => book['status'] == 'Reading').length;
    final completed =
        _books.where((book) => book['status'] == 'Completed').length;

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
            'Your reading collection',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$total Books',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _summaryItem(Icons.menu_book_rounded, '$reading Reading'),
              const SizedBox(width: 18),
              _summaryItem(
                Icons.check_circle_outline_rounded,
                '$completed Completed',
              ),
            ],
          ),
          const SizedBox(height: 18),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: total == 0 ? 0 : completed / total,
              minHeight: 6,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${total == 0 ? 0 : (completed / total * 100).round()}% completed',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
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
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildListBook(Map<String, dynamic> book) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = book['progress'] as double;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => _openBook(book),
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
                      book['category'] as String,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      book['title'] as String,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book['author'] as String,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (progress > 0) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor:
                              colorScheme.surfaceContainerHighest,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        '${(progress * 100).round()}% read',
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 11,
                        ),
                      ),
                    ] else
                      _statusBadge(book['status'] as String),
                  ],
                ),
              ),
              const SizedBox(width: 4),
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

  Widget _buildGridBook(Map<String, dynamic> book) {
    final colorScheme = Theme.of(context).colorScheme;
    final progress = book['progress'] as double;

    return Card(
      elevation: 0,
      color: colorScheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: () => _openBook(book),
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
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 11,
                ),
              ),
              const SizedBox(height: 8),
              if (progress > 0)
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  color: colorScheme.primary,
                  backgroundColor:
                      colorScheme.surfaceContainerHighest,
                )
              else
                _statusBadge(book['status'] as String),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(
    Map<String, dynamic> book, {
    required double width,
    required double height,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: book['color'] as Color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            book['icon'] as IconData,
            size: 42,
            color: Colors.white.withValues(alpha: 0.95),
          ),
          Positioned(
            bottom: 8,
            left: 6,
            right: 6,
            child: Text(
              book['title'] as String,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    final color = switch (status) {
      'Completed' => const Color(0xFF258455),
      'Reading' => const Color(0xFF3975C6),
      _ => const Color(0xFF8A7354),
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
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

  void _showSortOptions() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Filter books by status',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ..._filters.map(
                  (filter) => ListTile(
                    title: Text(filter),
                    trailing: _selectedFilter == filter
                        ? const Icon(
                            Icons.check_rounded,
                            color: primaryColor,
                          )
                        : null,
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                      Navigator.pop(context);
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
