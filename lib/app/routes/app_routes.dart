import 'package:get/get.dart';
import 'package:service_booking/features/service_booking/bindings/service_binding.dart';
import 'package:service_booking/features/service_booking/presentation/screen/service_screen.dart';

import '../../features/login/bindings/login_binding.dart';
import '../../features/login/presentation/screens/login_screen.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: '/',
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: '/serviceScreen',
      page: () => ServiceScreen(),
      binding: ServiceBinding(),
    ),
  ];
}
