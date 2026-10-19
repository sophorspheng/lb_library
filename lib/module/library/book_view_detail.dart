import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:lb_library/core/storage/offline_pdf_storage.dart';
import 'package:lb_library/module/library/widgets/book_download_button.dart';
import 'package:lb_library/module/login/model/get_book_list.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class BookViewDetail extends StatefulWidget {
  const BookViewDetail({
    super.key,
    required this.book,
    this.onRead,
    this.onFavoriteChanged,
  });

  final GetBookList book;
  final VoidCallback? onRead;
  final ValueChanged<bool>? onFavoriteChanged;

  @override
  State<BookViewDetail> createState() => _BookViewDetailState();
}

class _BookViewDetailState extends State<BookViewDetail> {
  late bool _isFavorite = widget.book.isFavorite;

  @override
  void didUpdateWidget(covariant BookViewDetail oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.book.id != widget.book.id) {
      _isFavorite = widget.book.isFavorite;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final book = widget.book;
    final subtitle = book.subtitle?.toString().trim();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book details'),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: _isFavorite ? 'Remove from wishlist' : 'Add to wishlist',
            onPressed: _toggleFavorite,
            icon: Icon(
              _isFavorite ? Icons.favorite_rounded : Icons.favorite_border,
              color: _isFavorite ? colors.error : null,
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        top: false,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
                child: Column(
                  children: [
                    _buildCover(colors),
                    const SizedBox(height: 24),
                    if (book.category.trim().isNotEmpty)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: colors.primaryContainer,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: Text(
                          book.category,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colors.onPrimaryContainer,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    const SizedBox(height: 12),
                    Text(
                      book.title,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5,
                        height: 1.15,
                      ),
                    ),
                    if (subtitle != null && subtitle.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    Text(
                      'by ${book.author}',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildRating(theme, colors),
                    const SizedBox(height: 26),
                    _buildBookStats(theme, colors),
                    const SizedBox(height: 28),
                    _buildDescription(theme, colors),
                    const SizedBox(height: 24),
                    _buildAdditionalDetails(theme, colors),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            children: [
              Expanded(child: BookDownloadButton(book: book, iconOnly: false)),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: widget.onRead ?? _openReader,
                    icon: const Icon(Icons.menu_book_rounded),
                    label: const Text('Start reading'),
                    style: FilledButton.styleFrom(
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCover(ColorScheme colors) {
    final cover = widget.book.coverImageUrl.trim();
    Widget image;

    if (cover.startsWith('https://') || cover.startsWith('http://')) {
      image = Image.network(
        cover,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => _coverPlaceholder(colors),
      );
    } else {
      final commaIndex = cover.indexOf(',');
      final encodedCover = cover.startsWith('data:') && commaIndex >= 0
          ? cover.substring(commaIndex + 1)
          : cover;
      try {
        image = Image.memory(
          base64Decode(encodedCover),
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _coverPlaceholder(colors),
        );
      } on FormatException {
        image = _coverPlaceholder(colors);
      }
    }

    return Container(
      width: 176,
      height: 246,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.secondaryContainer,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.22),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: image,
    );
  }

  Widget _coverPlaceholder(ColorScheme colors) {
    return Center(
      child: Icon(
        Icons.menu_book_rounded,
        size: 56,
        color: colors.onSecondaryContainer,
      ),
    );
  }

  Widget _buildRating(ThemeData theme, ColorScheme colors) {
    final rating = widget.book.rating.clamp(0, 5);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...List.generate(
          5,
          (index) => Icon(
            index < rating ? Icons.star_rounded : Icons.star_border_rounded,
            size: 20,
            color: const Color(0xFFE5A522),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${widget.book.rating.toStringAsFixed(1)}/5',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          '(${widget.book.totalRatings} ratings)',
          style: theme.textTheme.bodySmall?.copyWith(
            color: colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildBookStats(ThemeData theme, ColorScheme colors) {
    final details = [
      ('${widget.book.pageCount}', 'Pages', Icons.article_outlined),
      (widget.book.language, 'Language', Icons.language_rounded),
      (
        widget.book.publishedDate?.toString() ?? '—',
        'Published',
        Icons.calendar_month_outlined,
      ),
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: colors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          for (var index = 0; index < details.length; index++) ...[
            if (index > 0)
              Container(width: 1, height: 42, color: colors.outlineVariant),
            Expanded(
              child: Column(
                children: [
                  Icon(details[index].$3, size: 19, color: colors.primary),
                  const SizedBox(height: 6),
                  Text(
                    details[index].$1,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    details[index].$2,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDescription(ThemeData theme, ColorScheme colors) {
    final description = widget.book.description.trim();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this book',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          description.isEmpty
              ? 'No description is available yet.'
              : description,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: colors.onSurfaceVariant,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  Widget _buildAdditionalDetails(ThemeData theme, ColorScheme colors) {
    final isbn = widget.book.isbn?.toString();
    final details = <(String, String)>[
      ('Publisher', widget.book.publisher),
      if (isbn != null && isbn.isNotEmpty && isbn != 'null') ('ISBN', isbn),
      ('Availability', widget.book.isActive ? 'Available' : 'Unavailable'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Book information',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: colors.outlineVariant),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              for (var index = 0; index < details.length; index++) ...[
                if (index > 0) Divider(height: 1, color: colors.outlineVariant),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 13,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          details[index].$1,
                          style: TextStyle(color: colors.onSurfaceVariant),
                        ),
                      ),
                      Flexible(
                        child: Text(
                          details[index].$2,
                          textAlign: TextAlign.end,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() => _isFavorite = !_isFavorite);
    widget.onFavoriteChanged?.call(_isFavorite);
  }

  Future<void> _openReader() async {
    Uint8List? bytes;
    try {
      bytes = await OfflinePdfStorage.readPdf(widget.book.id);
    } on PdfStorageException catch (error) {
      _showReaderError(error.message);
      return;
    }

    if (bytes == null) {
      final source = widget.book.pdfBase64.trim();
      if (source.isEmpty) {
        _showReaderError('No PDF file is available for this book.');
        return;
      }

      final commaIndex = source.indexOf(',');
      final encodedPdf = source.startsWith('data:') && commaIndex >= 0
          ? source.substring(commaIndex + 1)
          : source;

      try {
        bytes = base64Decode(encodedPdf);
        if (bytes.length < 5 ||
            String.fromCharCodes(bytes.take(5)) != '%PDF-') {
          _showReaderError('The attached file is not a valid PDF.');
          return;
        }
      } on FormatException {
        _showReaderError('The PDF file could not be decoded.');
        return;
      }
    }

    if (!mounted) return;
    final pdfBytes = bytes;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            _BookPdfReader(title: widget.book.title, pdfBytes: pdfBytes),
      ),
    );
  }

  void _showReaderError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }
}

class _BookPdfReader extends StatefulWidget {
  const _BookPdfReader({required this.title, required this.pdfBytes});

  final String title;
  final Uint8List pdfBytes;

  @override
  State<_BookPdfReader> createState() => _BookPdfReaderState();
}

class _BookPdfReaderState extends State<_BookPdfReader> {
  String? _loadError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SafeArea(
        child: _loadError == null
            ? SfPdfViewer.memory(
                widget.pdfBytes,
                onDocumentLoadFailed: (details) {
                  if (mounted) {
                    setState(() {
                      _loadError = details.description;
                    });
                  }
                },
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'Could not display this PDF.\n$_loadError',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}
