import 'package:lb_library/core/network/helper_notifier.dart';
import 'package:lb_library/module/login/model/get_book_list.dart' as model;

class HomeService {
  Future<List<model.GetBookList>> getBookList() async {
    const baseUrl = 'api/usecure/getbookss';

    final response = await HelperNotifier.get(url: baseUrl);

    if (response is! List) {
      throw const FormatException(
        'Expected a list of books in the API response.',
      );
    }

    return response
        .map(
          (item) => model.GetBookList.fromJson(
            Map<String, dynamic>.from(item as Map),
          ),
        )
        .toList();
  }
}
