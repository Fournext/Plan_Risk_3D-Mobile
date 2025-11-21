import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/modeldetail.dart';

class ModelDetailScreen extends StatelessWidget {
  final ModelDetail model;

  const ModelDetailScreen({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),

      // ======= APPBAR =======
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: Text(
          model.title,
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      // ======= CUERPO =======
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // ===== ENCABEZADO =====
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  model.title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  model.dateText,
                  style: const TextStyle(color: Colors.black54, fontSize: 15),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ===== CONTENEDOR DEL MODELO =====
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: ModelViewer(
                    src: model.glbUrl,
                    alt: "Modelo 3D - ${model.title}",
                    ar: true,
                    autoRotate: true,
                    cameraControls: true,
                    shadowIntensity: 1,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // ===== BOTÓN PRINCIPAL =====
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.auto_awesome_rounded,
                  color: Colors.white,
                ),
                label: const Text(
                  "Ver Detalles Avanzados",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC5F00),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 14,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
