import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/app/routes/app_routes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/service',
      getPages: AppPages.routes,
    );
  }
}