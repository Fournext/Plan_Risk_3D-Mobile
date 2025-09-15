// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';

import 'config/app_themes.dart';
import 'config/theme_controller.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(ThemeController());

  // Selecciona la que corresponda:
  // const baseUrl = 'http://127.0.0.1:8000';   // navegador PC
  // const baseUrl = 'http://10.0.2.2:8000';    // emulador Android
  const baseUrl = 'http://192.168.0.3:8000';    // dispositivo físico

  Get.put(AuthController(baseUrl: baseUrl), permanent: true);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Plan Risk 3D',
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: themeController.theme,
      initialRoute: AppRoutes.splash,
      getPages: AppRoutes.pages,
      defaultTransition: Transition.fade,
    );
  }
}
