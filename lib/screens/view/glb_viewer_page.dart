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
  bool _isLoading = false;

  final String _defaultModel =
      'https://modelviewer.dev/shared-assets/models/Astronaut.glb';

  void _setUrl() {
    FocusScope.of(context).unfocus();
    setState(() {
      _errorMsg = null;
      final url = _urlController.text.trim();
      if (url.isEmpty || !(url.endsWith('.glb') || url.endsWith('.gltf'))) {
        _errorMsg = '⚠️ Ingresa una URL válida que termine en .glb o .gltf';
        _glbUrl = null;
      } else {
        _isLoading = true;
        Future.delayed(const Duration(milliseconds: 800), () {
          setState(() {
            _glbUrl = url;
            _isLoading = false;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final srcToShow = _glbUrl ?? _defaultModel;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),

      // ======= AppBar =======
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(65),
        child: SafeArea(
          bottom: false,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFFFFF8F0),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded,
                      color: Color(0xFF1E293B)),
                  onPressed: () => Navigator.pop(context),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.view_in_ar_rounded,
                    color: Color(0xFFDC5F00), size: 26),
                const SizedBox(width: 10),
                const Text(
                  "Visor 3D de Modelos",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      // ======= Cuerpo =======
      body: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Campo de texto URL
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _urlController,
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Pega la URL del modelo (.glb o .gltf)',
                  prefixIcon: Icon(Icons.link_rounded, color: Color(0xFFDC5F00)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                ),
              ),
            ),
            const SizedBox(height: 14),

            // Mensaje de error (si existe)
            if (_errorMsg != null)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.redAccent),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline,
                        color: Colors.redAccent, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMsg!,
                        style: const TextStyle(
                            color: Colors.redAccent, fontSize: 14),
                      ),
                    )
                  ],
                ),
              ),

            const SizedBox(height: 20),

            // ======= Visor 3D =======
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Stack(
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 600),
                        child: _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFFDC5F00),
                                  strokeWidth: 3,
                                ),
                              )
                            : ModelViewer(
                                key: ValueKey(srcToShow),
                                src: srcToShow,
                                alt: "Modelo 3D",
                                ar: true,
                                autoRotate: true,
                                cameraControls: true,
                                shadowIntensity: 1,
                                exposure: 1,
                                backgroundColor: Colors.white,
                              ),
                      ),
                      if (_glbUrl == null)
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.view_in_ar_rounded,
                                  size: 80, color: Color(0xFFDC5F00)),
                              SizedBox(height: 14),
                              Text(
                                "Cargar un modelo 3D para visualizarlo",
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ======= Botón flotante =======
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 10),
        child: ElevatedButton.icon(
          onPressed: _setUrl,
          icon: const Icon(Icons.cloud_download_rounded, color: Colors.white),
          label: const Text(
            'Cargar modelo',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
          ),
          style: ElevatedButton.styleFrom(
            elevation: 8,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            backgroundColor: const Color(0xFFDC5F00),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
