import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GlbViewerPage extends StatefulWidget {
  const GlbViewerPage({super.key});

  @override
  State<GlbViewerPage> createState() => _GlbViewerPageState();
}

class _GlbViewerPageState extends State<GlbViewerPage> {
  final _urlController = TextEditingController();
  String? _glbUrl;
  String? _errorMsg;

  final String _defaultModel = 'https://modelviewer.dev/shared-assets/models/Astronaut.glb';

  void _setUrl() {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorMsg = null;
      final url = _urlController.text.trim();
      if (url.isEmpty || !(url.endsWith('.glb') || url.endsWith('.gltf'))) {
        _errorMsg = 'Ingresa una URL válida que termine en .glb o .gltf';
        _glbUrl = null;
      } else {
        _glbUrl = url;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final srcToShow = _glbUrl ?? _defaultModel;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text('Visualizador 3D por URL'),
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
        child: Column(
          children: [
            // Campo de entrada
            TextField(
              controller: _urlController,
              decoration: InputDecoration(
                hintText: 'URL del modelo (.glb o .gltf)',
                prefixIcon: const Icon(Icons.link),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 12),

            // Botón de carga
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: _setUrl,
                icon: const Icon(Icons.cloud_download_rounded),
                label: const Text('Cargar modelo'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Mensaje de error
            if (_errorMsg != null)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: Colors.red, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMsg!,
                        style: const TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 16),

            // Visor 3D
            Expanded(
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: ModelViewer(
                    key: ValueKey(srcToShow),
                    src: srcToShow,
                    alt: "Modelo 3D",
                    ar: true,
                    autoRotate: true,
                    cameraControls: true,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
