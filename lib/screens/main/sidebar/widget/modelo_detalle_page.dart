import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';


//importacion de la constantes
import '../../../../const/app_constants.dart';


class ModeloDetallePage extends StatelessWidget {
  final Map<String, dynamic> modelo;
  const ModeloDetallePage({super.key, required this.modelo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseUrl = '${AppConstants.baseUrlPacht}';
    final glbUrl = "$baseUrl${modelo['glb_model']}";
    final planImg = "$baseUrl${modelo['plan_image']}";

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),

      // ======= AppBar =======
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: Text(
          "Modelo ID #${modelo['id']}",
          style: const TextStyle(
            color: Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),

      // ======= Contenido =======
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Sección de información ======
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "📋 Información del Modelo",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1E293B),
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildInfo("ID", modelo['id'].toString()),
                  _buildInfo("Archivo", modelo['plan_file']),
                  _buildInfo("Imagen", modelo['plan_image']),
                  _buildInfo("JSON detecciones", modelo['detections_json']),
                  _buildInfo("Dimensiones",
                      "${modelo['width']} × ${modelo['height']} px"),
                  _buildInfo("Usuario ID", modelo['usuario'].toString()),
                  _buildInfo("Fecha creación",
                      modelo['created_at'].toString().split('T').first),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ====== Enlace GLB ======
            const Text(
              "🔗 Enlace del modelo 3D",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 10),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      glbUrl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: glbUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('📋 Enlace copiado al portapapeles'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.copy, color: Color(0xFFDC5F00)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ====== Modelo 3D ======
            const Text(
              "🧱 Vista del Modelo 3D",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 14),

            Container(
              height: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: ModelViewer(
                  src: glbUrl,
                  alt: "Modelo 3D generado",
                  ar: true,
                  autoRotate: true,
                  cameraControls: true,
                  shadowIntensity: 1,
                  backgroundColor: Colors.white,
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ====== Imagen del plano original ======
            const Text(
              "📸 Imagen del plano original",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 14),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.network(
                  planImg,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Padding(
                    padding: EdgeInsets.all(30),
                    child: Icon(
                      Icons.broken_image,
                      size: 70,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // ====== Botón secundario opcional ======
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                label: const Text(
                  'Volver',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC5F00),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}