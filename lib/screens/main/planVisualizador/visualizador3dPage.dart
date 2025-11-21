import 'package:flutter/material.dart';



import 'package:model_viewer_plus/model_viewer_plus.dart';

class Visualizador3dPage extends StatefulWidget {
  const Visualizador3dPage({super.key});

  @override
  State<Visualizador3dPage> createState() => _Visualizador3dPageState();
}

class _Visualizador3dPageState extends State<Visualizador3dPage> {
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
        _errorMsg = '⚠️ Ingresa una URL válida (.glb o .gltf)';
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
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 2,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min, // 🔥 Esto es la clave
          children: [
            Icon(Icons.view_in_ar_rounded, color: Color(0xFFDC5F00)),
            SizedBox(width: 6),
            Text(
              "Visualizador 3D - Plan Risk Studio",
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),


      // ======= Cuerpo =======
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ======= Banner limpio =======
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                // Nota: Asegúrate de que esta ruta de imagen sea correcta
                // image: const DecorationImage(
                //   image: AssetImage('assets/images/banner_dashboard.png'),
                //   fit: BoxFit.cover,
                // ),
                color: const Color(0xFFDC5F00).withOpacity(0.1), // Placeholder si la imagen no existe
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: const Text(
                  "Explora tus modelos 3D\ncon un solo clic",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 28),

            // ======= Campo URL =======
            const Text(
              "URL del modelo 3D",
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 10),

            Container(
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
              child: TextField(
                controller: _urlController,
                style: const TextStyle(fontSize: 15),
                decoration: const InputDecoration(
                  hintText: 'Pega aquí la URL (.glb o .gltf)',
                  prefixIcon: Icon(Icons.link_rounded, color: Color(0xFFDC5F00)),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 14, horizontal: 14),
                ),
              ),
            ),

            if (_errorMsg != null) ...[
              const SizedBox(height: 10),
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
            ],

            const SizedBox(height: 28),

            // ======= Contenedor del visor =======
            Container(
              height: 320,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
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
                              backgroundColor: Colors.white,
                            ),
                    ),
                    if (_glbUrl == null)
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.view_in_ar_rounded,
                                size: 80, color: Color(0xFFDC5F00).withOpacity(_isLoading ? 0 : 1)),
                            const SizedBox(height: 14),
                            Text(
                              "Tu modelo 3D aparecerá aquí",
                              style: TextStyle(
                                color: Colors.black54.withOpacity(_isLoading ? 0 : 1),
                                fontSize: 15,
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

            const SizedBox(height: 35),

            // ======= Botón centrado =======
            Center(
              child: ElevatedButton.icon(
                onPressed: _setUrl,
                icon: const Icon(Icons.auto_awesome_rounded, color: Colors.white),
                label: const Text(
                  'Visualizar Modelo',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  elevation: 8,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 34, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  backgroundColor: const Color(0xFFDC5F00),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}