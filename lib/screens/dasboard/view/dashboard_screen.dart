import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/model3d_model.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/model_info.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/modeldetail.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/widgets/ModelDetailScreen.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/widgets/model_card.dart';

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
  ModelInfo(
    title: 'Análisis de Riesgo',
    dateText: 'Abr 28, 2025',
    thumbnailAsset: 'assets/images/model_risk.png',
    glbUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
  ),
  ModelInfo(
    title: 'Traje de astronauta',
    dateText: 'Ago 30, 2025',
    thumbnailAsset: 'assets/images/model_risk.png',
    glbUrl: 'https://modelviewer.dev/shared-assets/models/Astronaut.glb',
  ),
];


    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // realizar un baner con imagen de los serivcio que estamos oofreciendo 
            // trabajo pa seba 
            
            
Container(
  height: 160,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(24),
    gradient: const LinearGradient(
      colors: [Color(0xFF7C4DFF), Color(0xFF2251FF)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  ),
  child: Stack(
    children: [
      // Imagen portada en el fondo completo, sin cortar el texto
      Positioned.fill(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Image.asset(
            'assets/images/banner_dashboard.png',
            fit: BoxFit.cover,
          ),
        ),
      ),
      // Capa oscura para mejorar contraste del texto
      Positioned.fill(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.black.withOpacity(0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      // Texto encima
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
            const SizedBox(height: 8),
            Text(
              'Administra tus últimos modelos y proyectos.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.white.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    ],
  ),
),

            const SizedBox(height: 24),

            Text(
              'Modelos recientes',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),

            // ==== Tarjetas animadas ====
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
                  child: ModelCard(
  model: Model3D(
    title: m.title,
    date: m.dateText,
    thumbnailAsset: m.thumbnailAsset,
  ),
  onTap: () {
    Get.to(() => ModelDetailScreen(
      model: ModelDetail(
        title: m.title,
        dateText: m.dateText,
        glbUrl: m.glbUrl,
      ),
    ));
  },
)

                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}


