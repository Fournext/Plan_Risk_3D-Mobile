import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/model3d_model.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/model_info.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/modeldetail.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/widgets/ModelDetailScreen.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/widgets/model_card.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/mis_modelos_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final items = <ModelInfo>[
      ModelInfo(
        title: 'Edificio Principal',
        dateText: 'Abr 30, 2025',
        thumbnailAsset: 'assets/images/model_office.png',
        glbUrl: 'assets/models/edificio.glb',
      ),


    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // ===== Banner superior =====
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Imagen de fondo
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Image.asset(
                        'assets/images/banner_dashboard.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Gradiente de superposición
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [
                            Colors.black.withOpacity(0.45),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Texto
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '¡Bienvenido de nuevo!',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Administra tus últimos modelos y proyectos.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ===== Título de sección =====
            Text(
              'Modelos de Prueba',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: const Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 18),

            // ===== Tarjetas animadas =====
            ...List.generate(items.length, (i) {
              final m = items[i];
              return TweenAnimationBuilder<double>(
                key: ValueKey(m.title),
                duration: Duration(milliseconds: 400 + i * 120),
                curve: Curves.easeOutCubic,
                tween: Tween(begin: 0, end: 1),
                builder: (_, v, child) => Transform.translate(
                  offset: Offset(0, 40 * (1 - v)),
                  child: Opacity(opacity: v, child: child),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ModelCard(
                      model: Model3D(
                        title: m.title,
                        date: m.dateText,
                        thumbnailAsset: m.thumbnailAsset,
                      ),
                      onTap: () {
                        Get.to(
                          () => ModelDetailScreen(
                            model: ModelDetail(
                              title: m.title,
                              dateText: m.dateText,
                              glbUrl: m.glbUrl,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            }),

            const SizedBox(height: 30),

            // ===== Sección: Mis Modelos =====
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child:  MisModelosSection(),
            ),
          ],
        ),
      ),
    );
  }
}
