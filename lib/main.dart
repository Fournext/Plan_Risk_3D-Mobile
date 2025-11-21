// lib/main.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_plan_risk_3d/screens/auth/controller/model_controller.dart';
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';

import 'config/app_themes.dart';
import 'config/theme_controller.dart';
import 'routes/routes.dart';

// -- importacion de las constantes
import 'const/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();

  Get.put(ThemeController());

  //const baseUrl = 'http://10.13.114.28:8000/'; // dispositivo físico
  //const baseUrl = 'http://ec2-18-222-5-143.us-east-2.compute.amazonaws.com:8000/';

  // aqui esta el general
  const baseUrl = AppConstants.baseUrl;

  Get.put(AuthController(baseUrl: baseUrl), permanent: true);
Get.put(ModelController()); // ⬅️ AÑADIR ESTO OBLIGATORIO
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
