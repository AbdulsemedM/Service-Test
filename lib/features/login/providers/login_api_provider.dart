import 'package:get/get.dart';

class LoginApiProvider extends GetConnect {
  Future<bool> login(String username, String password) async {
    await Future.delayed(Duration(seconds: 2));

    if (username == 'test' && password == 'test') {
      return true;
    }
    return false;
  }
}
