import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class GlbViewerPage extends StatefulWidget {
  const GlbViewerPage({Key? key}) : super(key: key);

  @override
  State<GlbViewerPage> createState() => _GlbViewerPageState();
}

class _GlbViewerPageState extends State<GlbViewerPage> {
  String? _glbUrl;
  String? _errorMsg;
  final String _defaultModel = 'https://modelviewer.dev/shared-assets/models/Astronaut.glb';
  final TextEditingController _urlController = TextEditingController();


  void _setUrl() {
    FocusScope.of(context).unfocus(); // Cierra el teclado y quita el foco
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
  String srcToShow = _glbUrl?.trim() ?? _defaultModel;
    return Scaffold(
      appBar: AppBar(title: const Text('Visualizador GLB por URL')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: _urlController,
                decoration: const InputDecoration(
                  labelText: 'URL del modelo .glb o .gltf',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _setUrl,
              child: const Text('Cargar modelo desde URL'),
            ),
            const SizedBox(height: 20),
            if (_errorMsg != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(_errorMsg!, style: const TextStyle(color: Colors.red)),
              ),
            Expanded(
              child: ModelViewer(
                key: ValueKey(srcToShow),
                src: srcToShow,
                alt: "Modelo 3D",
                ar: true,
                autoRotate: true,
                cameraControls: true,
              ),
            ),
            const SizedBox(height: 20),
           
          ],
        ),
      ),
    );
  }
}
