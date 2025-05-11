import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:service_booking/app/language_manager.dart';
import '../../controllers/login_controller.dart';
import '../../../../app/utils/app_colors.dart';

class LoginWidget extends StatelessWidget {
  final LoginController controller;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  LoginWidget({
    required this.controller,
    required this.usernameController,
    required this.passwordController,
    required this.formKey,
  });

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
            backgroundColor: Colors.grey[200],
            title: Text('Choose Language'.tr),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        child: Text(locale[index]['name']),
                        onTap: () async {
                          String selectedLocale = locale[index]['name'];
                          LanguageManager preferences = LanguageManager();
                          await preferences.setLanguage(selectedLocale);

                          updateLanguage(locale[index]['locale']);
                        },
                      ),
                    );
                  },
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey,
                    );
                  },
                  itemCount: locale.length),
            ),
          );
        });
  }

  final List locale = [
    {'name': 'English', 'locale': const Locale('en', 'US')},
    {'name': 'Spanish', 'locale': const Locale('es', 'ES')},
    {'name': 'Portuguese', 'locale': const Locale('pt', 'PT')},
  ];
  updateLanguage(Locale locale) async {
    Get.back();
    Get.updateLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () async {
                  await buildLanguageDialog(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        "English".tr,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const Icon(Icons.arrow_drop_down)
                    ],
                  ),
                ),
              ),
              Image.asset('assets/images/logo.png', width: 400, height: 150),
              Hero(
                tag: 'loginHero',
                child: Text(
                  'Welcome Back!'.tr,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: AppColors.primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: usernameController,
                      label: 'Username'.tr,
                      icon: Icons.person,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: passwordController,
                      label: 'Password'.tr,
                      icon: Icons.lock,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (controller.isLoading.value) {
                  return CircularProgressIndicator();
                }
                return ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      controller.login(
                        usernameController.text,
                        passwordController.text,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text('Login'.tr),
                );
              }),
              Obx(() {
                if (controller.errorMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      controller.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                }
                return SizedBox.shrink();
              }),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Text(
                      'Forgot Password?'.tr,
                      style: const TextStyle(
                        color: AppColors.secondaryDarkColor,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 80),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: GestureDetector(
                  onTap: () {},
                  child: Text(
                    "Don't have an account? Sign Up".tr,
                    style: const TextStyle(color: AppColors.secondaryDarkColor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.iconColor),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        fillColor: AppColors.greyColor,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $label';
        }
        return null;
      },
    );
  }
}
