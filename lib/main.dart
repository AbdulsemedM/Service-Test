import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/app/routes/app_routes.dart';
import 'package:service_booking/app/utils/app_themes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Service Booking',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: AppPages.routes,
    );
  }
}
