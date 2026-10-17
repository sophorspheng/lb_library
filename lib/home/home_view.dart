// import 'package:flutter/material.dart';
// import 'package:lb_library/config/theme/app_color.dart';
// import 'package:lb_library/languages/generated/l10n.dart';

// class HomeView extends StatelessWidget {
//   const new({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       bottom: false,
//       child: CustomScrollView(
//         keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
//         slivers: [
//           // Brand header scrolls away
//           SliverToBoxAdapter(
//             child: Padding(
//               padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
//               child: _buildHeader(),
//             ),
//           ),

//           SliverAppBar(
//             pinned: true,
//             floating: false,
//             automaticallyImplyLeading: false,
//             // backgroundColor: colorScheme.surface,
//             surfaceTintColor: Colors.transparent,
//             elevation: 0,
//             scrolledUnderElevation: 0,
//             toolbarHeight: 78,
//             titleSpacing: 20,
//             title: _buildSearchBar(),
//           ),

//           SliverPadding(
//             padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
//             sliver: SliverList(
//               delegate: SliverChildListDelegate([
//                 _buildSectionTitle(S.of(context).exploreCategories),
//                 const SizedBox(height: 16),
//                 _buildCategories(),

//                 const SizedBox(height: 28),

//                 _buildSectionTitle(S.of(context).featuredBooks),
//                 const SizedBox(height: 16),
//                 _buildFeaturedBooks(),

//                 const SizedBox(height: 28),

//                 _buildReadingBanner(),

//                 const SizedBox(height: 28),

//                 _buildSectionTitle(S.of(context).popularBooks),
//                 const SizedBox(height: 12),
//                 ...books.map(_buildBookTile),
//               ]),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Container(
//           height: 50,
//           width: 50,
//           decoration: BoxDecoration(
//             color: primaryColor,
//             borderRadius: BorderRadius.circular(16),
//           ),
//           child: const Icon(
//             Icons.menu_book_rounded,
//             color: Colors.white,
//             size: 28,
//           ),
//         ),
//         const SizedBox(width: 12),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 S.of(context).hometitle,
//                 style: const TextStyle(
//                   fontSize: 23,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 4),
//               Text(S.of(context).discoverBooks),
//             ],
//           ),
//         ),
//         IconButton(
//           onPressed: () {},
//           icon: const Icon(Icons.notifications_none_rounded),
//         ),
//         IconButton(
//           onPressed: () {
//             appThemeController.setThemeMode(
//               appThemeController.themeMode == ThemeMode.dark
//                   ? ThemeMode.light
//                   : ThemeMode.dark,
//             );
//           },
//           icon: Icon(
//             appThemeController.themeMode == ThemeMode.dark
//                 ? Icons.brightness_2
//                 : Icons.brightness_2_rounded,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSearchBar() {
//     final colorScheme = Theme.of(context).colorScheme;

//     return TextField(
//       focusNode: _searchFocusNode,
//       textInputAction: TextInputAction.search,
//       onTapOutside: (_) => KeyboardUtils.hide(),
//       onSubmitted: (_) => KeyboardUtils.hide(),
//       decoration: InputDecoration(
//         hintText: S.of(context).searchBooksAuthors,
//         hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
//         prefixIcon: const Icon(Icons.search_rounded),
//         suffixIcon: IconButton(
//           tooltip: S.of(context).filterBooks,
//           onPressed: () {},
//           icon: const Icon(Icons.tune_rounded),
//         ),
//         filled: true,
//         // fillColor: colorScheme.surfaceContainerHighest,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(18),
//           borderSide: BorderSide.none,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(18),
//           borderSide: BorderSide.none,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(18),
//           borderSide: BorderSide(
//             color: colorScheme.primary.withValues(alpha: 0.5),
//           ),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 16),
//       ),
//     );
//   }

//   Widget _buildSectionTitle(String title) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return Row(
//       children: [
//         Expanded(
//           child: Text(
//             title,
//             style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
//           ),
//         ),
//         TextButton(
//           onPressed: () {},
//           child: Text(
//             S.of(context).seeAll,
//             style: TextStyle(color: colorScheme.primary),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildCategories() {
//     final colorScheme = Theme.of(context).colorScheme;

//     return SizedBox(
//       height: 105,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: categories.length,
//         separatorBuilder: (_, _) => const SizedBox(width: 18),
//         itemBuilder: (context, index) {
//           final category = categories[index];

//           return SizedBox(
//             width: 75,
//             child: Column(
//               children: [
//                 Container(
//                   height: 58,
//                   width: 58,
//                   decoration: BoxDecoration(
//                     color: colorScheme.secondaryContainer,
//                     borderRadius: BorderRadius.circular(18),
//                   ),
//                   child: Icon(
//                     category['icon'] as IconData,
//                     color: colorScheme.primary,
//                     size: 27,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   _categoryName(category['name'] as String),
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontSize: 12),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildFeaturedBooks(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;

//     return SizedBox(
//       height: 230,
//       child: ListView.separated(
//         scrollDirection: Axis.horizontal,
//         itemCount: books.length,
//         separatorBuilder: (_, _) => const SizedBox(width: 14),
//         itemBuilder: (context, index) {
//           final book = books[index];

//           return SizedBox(
//             width: 145,
//             child: InkWell(
//               borderRadius: BorderRadius.circular(16),
//               onTap: () => _openBook(book),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: Container(
//                       width: double.infinity,
//                       decoration: BoxDecoration(
//                         color: book['color'] as Color,
//                         borderRadius: BorderRadius.circular(14),
//                       ),
//                       child: Icon(
//                         book['icon'] as IconData,
//                         size: 65,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     book['title'] as String,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     book['author'] as String,
//                     maxLines: 1,
//                     style: TextStyle(
//                       fontSize: 12,
//                       color: colorScheme.onSurfaceVariant,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildReadingBanner(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: AppColor.active,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   S.of(context).continueReading,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   S.of(context).continueReadingJourney,
//                   style: const TextStyle(color: Colors.white70, fontSize: 13),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(width: 10),
//           const Icon(Icons.menu_book_rounded, color: Colors.white, size: 48),
//         ],
//       ),
//     );
//   }

//   Widget _buildBookTile(Map<String, dynamic> book, BuildContext context) {
//     return Card(
//       elevation: 0,
//       margin: const EdgeInsets.only(bottom: 12),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(10),
//         leading: Container(
//           height: 60,
//           width: 55,
//           decoration: BoxDecoration(
//             color: book['color'] as Color,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Icon(book['icon'] as IconData, color: Colors.white),
//         ),
//         title: Text(
//           book['title'] as String,
//           style: const TextStyle(fontWeight: FontWeight.bold),
//         ),
//         subtitle: Text(book['author'] as String),
//         trailing: IconButton(
//           icon: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
//           onPressed: () => _openBook(book, context),
//         ),
//         onTap: () => _openBook(book, context),
//       ),
//     );
//   }

//   void _openBook(Map<String, dynamic> book, BuildContext context) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Selected: ${book['title']}'),
//         behavior: SnackBarBehavior.floating,
//       ),
//     );
//   }

//   String _categoryName(String category, BuildContext context) {
//     final localizations = S.of(context);
//     return switch (category) {
//       'Fiction' => localizations.fiction,
//       'Education' => localizations.education,
//       'History' => localizations.history,
//       'Science' => localizations.science,
//       _ => category,
//     };
//   }
// }
