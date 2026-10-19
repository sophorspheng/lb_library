import 'package:flutter/material.dart';
import 'package:lb_library/core/storage/offline_pdf_storage.dart';
import 'package:lb_library/module/login/model/get_book_list.dart';

class BookDownloadButton extends StatefulWidget {
  const BookDownloadButton({
    required this.book,
    this.iconOnly = true,
    super.key,
  });

  static final ValueNotifier<int> downloadRevision = ValueNotifier<int>(0);

  final GetBookList book;
  final bool iconOnly;

  @override
  State<BookDownloadButton> createState() => _BookDownloadButtonState();
}

class _BookDownloadButtonState extends State<BookDownloadButton> {
  bool _isDownloaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    BookDownloadButton.downloadRevision.addListener(_checkDownloaded);
    _checkDownloaded();
  }

  @override
  void didUpdateWidget(covariant BookDownloadButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.book.id != widget.book.id) {
      _checkDownloaded();
    }
  }

  @override
  void dispose() {
    BookDownloadButton.downloadRevision.removeListener(_checkDownloaded);
    super.dispose();
  }

  Future<void> _checkDownloaded() async {
    try {
      final isDownloaded = await OfflinePdfStorage.isDownloaded(widget.book.id);
      if (mounted) setState(() => _isDownloaded = isDownloaded);
    } on PdfStorageException catch (error) {
      _showMessage(error.message);
    }
  }

  Future<void> _download() async {
    if (_isLoading) return;
    if (_isDownloaded) {
      _showMessage('This book is saved for offline reading.');
      return;
    }
    setState(() => _isLoading = true);
    try {
      await OfflinePdfStorage.saveBook(widget.book);
      if (!mounted) return;
      setState(() => _isDownloaded = true);
      BookDownloadButton.downloadRevision.value++;
      _showMessage('Saved "${widget.book.title}" for offline reading.');
    } on FormatException catch (error) {
      _showMessage(error.message);
    } on UnsupportedError catch (error) {
      _showMessage(error.message ?? 'Downloads are not supported here.');
    } on PdfStorageException catch (error) {
      _showMessage(error.message);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final label = _isDownloaded ? 'Downloaded' : 'Download PDF';
    final icon = _isLoading
        ? null
        : _isDownloaded
        ? Icons.download_done_rounded
        : Icons.download_rounded;

    if (widget.iconOnly) {
      return IconButton(
        tooltip: label,
        onPressed: _isLoading ? null : _download,
        visualDensity: VisualDensity.compact,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
        icon: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Icon(icon, color: _isDownloaded ? colorScheme.primary : null),
      );
    }

    return OutlinedButton.icon(
      onPressed: _isLoading ? null : _download,
      icon: _isLoading
          ? const SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(icon),
      label: Text(label),
    );
  }
}
