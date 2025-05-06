import 'package:get/get.dart';
import 'package:service_booking/features/service_booking/bindings/service_binding.dart';
import 'package:service_booking/features/service_booking/presentation/screen/service_screen.dart';

class AppPages {
  static final List<GetPage<dynamic>> routes = [
    GetPage(
      name: '/service',
      page: () => const ServiceScreen(),
      binding: ServiceBinding(),
    ),
    // GetPage(
    //   name: '/home',
    //   page: () => HomeView(),
    //   binding: HomeBinding(),
    // ),
  ];
}
