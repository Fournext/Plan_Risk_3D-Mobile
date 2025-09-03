import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../auth/service/auth_controller.dart';
import '../../routes/routes.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});
  final _auth = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (_auth.isFirstTime) {
        Get.offAllNamed(AppRoutes.onboarding);
      } else if (_auth.isLoggedIn) {
        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.offAllNamed(AppRoutes.signin);
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.8),
              Theme.of(context).primaryColor.withOpacity(0.6),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: Opacity(opacity: 0.05, child: GridPattern(color: Colors.white))),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1200),
                    builder: (_, v, __) {
                      return Transform.scale(
                        scale: v,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white, shape: BoxShape.circle,
                            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, spreadRadius: 2, offset: const Offset(0, 4))],
                          ),
                          child: Icon(Icons.architecture, size: 48, color: Theme.of(context).primaryColor),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 1200),
                    builder: (_, v, __) => Opacity(
                      opacity: v,
                      child: Transform.translate(
                        offset: Offset(0, 20 * (1 - v)),
                        child: Column(
                          children: const [
                            Text('PLAN RISK', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w300, letterSpacing: 8)),
                            Text('3D', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w600, letterSpacing: 4)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 48, left: 0, right: 0,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1200),
                builder: (_, v, child) => Opacity(opacity: v, child: child),
                child: Text(
                  'generación de estructuras desde planos.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14, letterSpacing: 2, fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPattern extends StatelessWidget {
  final Color color;
  const GridPattern({super.key, required this.color});

  @override
  Widget build(BuildContext context) => CustomPaint(painter: GridPainter(color: color));
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..strokeWidth = 0.5;
    const spacing = 20.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
