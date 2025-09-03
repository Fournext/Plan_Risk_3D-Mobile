import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  final _box = GetStorage();
  final _key = 'isDarkMode';

  ThemeMode get theme => _loadTheme() ? ThemeMode.dark : ThemeMode.light;
  bool get isDarkMode => _loadTheme();

  bool _loadTheme() => _box.read(_key) ?? false;
  void saveTheme(bool isDark) => _box.write(_key, isDark);

  void toggleTheme() {
    Future.delayed(const Duration(milliseconds: 50), () {
      final next = !_loadTheme();
      saveTheme(next);
      Get.changeThemeMode(next ? ThemeMode.dark : ThemeMode.light);
      update();
    });
  }
}
