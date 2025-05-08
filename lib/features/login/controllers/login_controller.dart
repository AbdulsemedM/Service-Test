import 'package:get/get.dart';
import '../providers/login_api_provider.dart';

class LoginController extends GetxController {
  final LoginApiProvider apiProvider = LoginApiProvider();
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  Future<void> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    bool success = await apiProvider.login(username, password);
    isLoading.value = false;

    if (success) {
      Get.offNamed('/serviceScreen');
    } else {
      errorMessage.value = 'Invalid username or password';
    }
  }
}
