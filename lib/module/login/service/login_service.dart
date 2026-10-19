import 'package:lb_library/core/network/helper_notifier.dart';
import 'package:lb_library/module/login/model/register_request.dart';
import 'package:lb_library/module/login/model/user_model.dart';

class LoginService {
  Future<UserModel> authUser({
    required String username,
    required String password,
  }) async {
    const baseUrl = 'auth/login';

    final response = await HelperNotifier.post(
      url: baseUrl,
      data: {'username': username, 'password': password},
    );
    return UserModel.fromJson(response);
  }

  Future<void> registerUser({
    required RegisterRequest registerRequest,
  }) async {
    const baseUrl = 'auth/register';

    await HelperNotifier.post<dynamic>(
      url: baseUrl,
      data: registerRequest.toJson(),
    );
  }

}
