import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lb_library/core/network/network_api.dart';
import 'package:lb_library/module/login/model/get_book_list.dart';

void main() {
  test('parses decimal and integer ratings as doubles', () {
    expect(GetBookList.fromJson(_bookJson(rating: 0.0)).rating, 0.0);
    expect(GetBookList.fromJson(_bookJson(rating: 4)).rating, 4.0);
  });

  test(
    'routes Android emulator loopback API overrides through host bridge',
    () {
      final originalPlatform = debugDefaultTargetPlatformOverride;
      debugDefaultTargetPlatformOverride = TargetPlatform.android;
      addTearDown(() {
        debugDefaultTargetPlatformOverride = originalPlatform;
      });

      expect(NetworkAPI.instance.getBaseUrl(), 'http://10.0.2.2:8080/');
    },
  );
}

Map<String, dynamic> _bookJson({required num rating}) => {
  'author': 'Author',
  'category': 'Fiction',
  'coverImageUrl': '',
  'createdAt': '',
  'description': '',
  'id': 1,
  'isActive': true,
  'isFavorite': false,
  'isbn': null,
  'language': 'en',
  'pageCount': 100,
  'pdfBase64': '',
  'pdfContentType': 'application/pdf',
  'pdfFileName': null,
  'pdfSizeBytes': null,
  'publishedDate': null,
  'publisher': 'Publisher',
  'rating': rating,
  'subtitle': null,
  'title': 'Book',
  'totalRatings': 0,
  'updatedAt': '',
};
