import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';

import '../../../config/app_textstyles.dart';
import '../../routes/routes.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _items = <_OnboardingItem>[
    _OnboardingItem(
      title: 'Modelos 3D Automáticos',
      description:
          'Genera automáticamente modelos estructurales en 3D a partir de planos arquitectónicos.',
      image: 'assets/images/INT11.png',
    ),
    _OnboardingItem(
      title: 'Predicción de Riesgos',
      description:
          'Detecta riesgos potenciales en diseño y construcción usando IA.',
      image: 'assets/images/INT22.png',
    ),
    _OnboardingItem(
      title: 'Diseño Interno Asistido por IA',
      description:
          'Optimiza el diseño interno con asistencia de IA para mayor seguridad y eficiencia.',
      image: 'assets/images/INT33.png',
    ),
  ];

  void _handleGetStarted() {
    Get.find<AuthController>().setFirstTimeDone();
    Get.offAllNamed(AppRoutes.signin);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _items.length,
            onPageChanged: (i) => setState(() => _currentPage = i),
            itemBuilder: (_, i) {
              final it = _items[i];
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    it.image,
                    height: MediaQuery.of(context).size.height * 0.4,
                  ),
                  const SizedBox(height: 40),
                  Text(
                    it.title,
                    textAlign: TextAlign.center,
                    style: AppTextStyle.withColor(
                      AppTextStyle.h1,
                      Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Text(
                      it.description,
                      textAlign: TextAlign.center,
                      style: AppTextStyle.withColor(
                        AppTextStyle.bodyLarge,
                        isDark ? Colors.grey[400]! : Colors.grey[600]!,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: _handleGetStarted,
                  child: Text(
                    'Omitir',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage < _items.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _handleGetStarted();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    _currentPage < _items.length - 1 ? 'Siguiente' : 'Comenzar',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingItem {
  final String image, title, description;
  const _OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
  });
}
