import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:lb_library/core/storage/pdf_storage_exception.dart';
import 'package:lb_library/module/login/model/get_book_list.dart';
import 'package:path_provider/path_provider.dart';

class OfflinePdfStorage {
  static Future<Directory> _downloadDirectory() async {
    final documents = await getApplicationDocumentsDirectory();
    final directory = Directory('${documents.path}/downloaded_books');
    await directory.create(recursive: true);
    return directory;
  }

  static Future<String> saveBook(GetBookList book) async {
    final encodedPdf = book.pdfBase64.trim();
    if (encodedPdf.isEmpty) {
      throw const FormatException('No PDF file is available for this book.');
    }

    final commaIndex = encodedPdf.indexOf(',');
    final data = encodedPdf.startsWith('data:') && commaIndex >= 0
        ? encodedPdf.substring(commaIndex + 1)
        : encodedPdf;
    final bytes = base64Decode(data);
    if (bytes.length < 5 || String.fromCharCodes(bytes.take(5)) != '%PDF-') {
      throw const FormatException('The attached file is not a valid PDF.');
    }

    try {
      final directory = await _downloadDirectory();
      final pdfFile = File('${directory.path}/${book.id}.pdf');
      final metadataFile = File('${directory.path}/${book.id}.json');
      final metadata = book.toJson()..['pdfBase64'] = '';

      await pdfFile.writeAsBytes(bytes, flush: true);
      await metadataFile.writeAsString(jsonEncode(metadata), flush: true);
      return pdfFile.path;
    } on FileSystemException catch (error) {
      throw PdfStorageException('Could not save the PDF: ${error.message}');
    }
  }

  static Future<bool> isDownloaded(int bookId) async {
    try {
      final directory = await _downloadDirectory();
      return await File('${directory.path}/$bookId.pdf').exists();
    } on FileSystemException catch (error) {
      throw PdfStorageException(
        'Could not check downloaded PDFs: ${error.message}',
      );
    }
  }

  static Future<Uint8List?> readPdf(int bookId) async {
    try {
      final directory = await _downloadDirectory();
      final file = File('${directory.path}/$bookId.pdf');
      if (!await file.exists()) return null;
      return await file.readAsBytes();
    } on FileSystemException catch (error) {
      throw PdfStorageException(
        'Could not read the downloaded PDF: ${error.message}',
      );
    }
  }

  static Future<List<GetBookList>> getDownloadedBooks() async {
    try {
      final directory = await _downloadDirectory();
      final books = <GetBookList>[];
      await for (final entity in directory.list()) {
        if (entity is! File || !entity.path.endsWith('.json')) continue;
        final metadataFile = entity;
        final pdfPath =
            '${metadataFile.path.substring(0, metadataFile.path.length - 5)}.pdf';
        if (!await File(pdfPath).exists()) continue;
        final json = jsonDecode(await metadataFile.readAsString());
        if (json is! Map) {
          throw const FormatException('Downloaded book metadata is invalid.');
        }
        books.add(GetBookList.fromJson(Map<String, dynamic>.from(json)));
      }
      books.sort(
        (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
      );
      return books;
    } on FileSystemException catch (error) {
      throw PdfStorageException(
        'Could not load downloaded books: ${error.message}',
      );
    }
  }
}
