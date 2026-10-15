import 'package:lb_library/core/network/helper_notifier.dart';

class HomeService {
  Future<void> GetList({required String name}) async {
    final baseUrl = "";
    final response = await HelperNotifier.postParam(url: baseUrl, data: {});
    return response;
  }
}