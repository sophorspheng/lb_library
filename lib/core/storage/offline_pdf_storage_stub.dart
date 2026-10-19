import 'dart:typed_data';

import 'package:lb_library/module/login/model/get_book_list.dart';

class OfflinePdfStorage {
  static Future<String> saveBook(GetBookList book) async {
    throw UnsupportedError('PDF downloads are not supported on this platform.');
  }

  static Future<bool> isDownloaded(int bookId) async => false;

  static Future<Uint8List?> readPdf(int bookId) async => null;

  static Future<List<GetBookList>> getDownloadedBooks() async => [];
}
