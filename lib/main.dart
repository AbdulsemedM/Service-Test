import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/app/routes/app_routes.dart';
import 'package:service_booking/app/utils/app_themes.dart';
import 'package:service_booking/app/utils/app_translation.dart';
import 'package:service_booking/app/language_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? lang = await LanguageManager().getLanguage();
  lang ??= '';
  runApp(MyApp(lang: lang));
}

class MyApp extends StatelessWidget {
  final String lang;
  MyApp({required this.lang});
  @override
  Widget build(BuildContext context) {
    ScreenConfig.init(context);

    return GetMaterialApp(
      translations: AppTranslation(),
      locale: lang == "English"
          ? const Locale('en', 'US')
          : lang == "Spanish"
              ? const Locale('es', 'ES')
              : lang == "Portuguese"
                  ? const Locale('pt', 'PT')
                  : const Locale("en", "US"),
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
