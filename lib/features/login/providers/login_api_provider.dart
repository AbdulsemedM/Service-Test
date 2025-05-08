import 'package:get/get.dart';

class LoginApiProvider extends GetConnect {
  Future<bool> login(String username, String password) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Mock login logic
    if (username == 'test' && password == 'test') {
      return true;
    }
    return false;
  }
}
