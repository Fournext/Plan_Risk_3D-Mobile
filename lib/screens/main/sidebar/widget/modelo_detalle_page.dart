import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ModeloDetallePage extends StatelessWidget {
  final Map<String, dynamic> modelo;
  const ModeloDetallePage({super.key, required this.modelo});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseUrl = "http://10.0.2.2:8000";
    final glbUrl = "$baseUrl${modelo['glb_model']}";
    final planImg = "$baseUrl${modelo['plan_image']}";

    return Scaffold(
      appBar: AppBar(
        title: Text("Modelo ID #${modelo['id']}"),
        backgroundColor: const Color(0xFF042940),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF4F6FD),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ====== Datos del modelo ======
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📋 Información del Modelo",
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
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

            const SizedBox(height: 24),

            // ====== Enlace GLB + copiar ======
            Text("🔗 Enlace del modelo 3D:",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 6,
                      offset: const Offset(0, 3))
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      glbUrl,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: glbUrl));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('✅ Enlace copiado al portapapeles')),
                      );
                    },
                    icon: const Icon(Icons.copy, color: Colors.indigo),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ====== Renderizado 3D ======
            Text("🧱 Vista del Modelo 3D",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            Container(
              height: 380,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 5))
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

            const SizedBox(height: 24),

            // ====== Imagen del plano ======
            Text("📸 Imagen del plano original",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                planImg,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Icon(
                  Icons.broken_image,
                  size: 60,
                  color: Colors.grey,
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
          Text("$label: ",
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black87)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
