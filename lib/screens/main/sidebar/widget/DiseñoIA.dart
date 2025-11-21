import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../../const/app_constants.dart';

class IADisenoScreen extends StatefulWidget {
  const IADisenoScreen({super.key});

  @override
  State<IADisenoScreen> createState() => _IADisenoScreenState();
}

class _IADisenoScreenState extends State<IADisenoScreen>
    with SingleTickerProviderStateMixin {
  String? _glbUrl;
  double _opacity = 0.0;
  File? _selectedImage;
  bool _isLoading = false;
  final _box = GetStorage();
  final String baseUrl = '${AppConstants.baseUrl}api/set_plan/plans/';

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  Future<void> _uploadPlan() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Primero selecciona o toma una foto')),
      );
      return;
    }

    final user = _box.read('usuario');
    if (user == null || user['id'] == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('⚠️ Usuario no encontrado')));
      return;
    }

    setState(() {
      _isLoading = true;
      _glbUrl = null; // limpiar visor hasta que llegue respuesta
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl))
        ..fields['usuario'] = user['id'].toString()
        ..files.add(
          await http.MultipartFile.fromPath('plan_file', _selectedImage!.path),
        );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      // parsear JSON si es posible
      if (response.statusCode == 201) {
        try {
          final Map<String, dynamic> jsonResp = jsonDecode(responseBody);
          // Ajusta la clave según tu respuesta real
          final dynamic glbField = jsonResp['glb_model'] ?? jsonResp['glb'] ?? jsonResp['model_url'];

          if (glbField != null && glbField is String && glbField.isNotEmpty) {
            final fullUrl = glbField.startsWith('http')
                ? glbField
                : '${AppConstants.baseUrlPacht}$glbField';

            setState(() => _glbUrl = fullUrl);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Modelo generado correctamente')),
            );
          } else {
            // fallback a regex si backend no responde en JSON esperado
            final regex = RegExp(r'"glb_model"\s*:\s*"([^"]+)"');
            final match = regex.firstMatch(responseBody);
            if (match != null) {
              final glbPath = match.group(1)!;
              final fullUrl = '${AppConstants.baseUrlPacht}$glbPath';
              setState(() => _glbUrl = fullUrl);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Modelo generado correctamente')),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('⚠️ No se encontró la URL del modelo en la respuesta')),
              );
            }
          }
        } catch (e) {
          // si jsonDecode falla, intentar con regex
          final regex = RegExp(r'"glb_model"\s*:\s*"([^"]+)"');
          final match = regex.firstMatch(responseBody);
          if (match != null) {
            final glbPath = match.group(1)!;
            final fullUrl = '${AppConstants.baseUrlPacht}$glbPath';
            setState(() => _glbUrl = fullUrl);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('✅ Modelo generado correctamente')),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('⚠️ Respuesta inesperada: $responseBody')),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('❌ Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Copiar al portapapeles
  Future<void> _copyToClipboard(String text, {String? label}) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label ?? '📋 Enlace copiado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F0),
        elevation: 2,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.auto_awesome_rounded, color: Color(0xFFDC5F00)),
            SizedBox(width: 6),
            Text(
              'IA Diseño',
              style: TextStyle(
                color: Color(0xFF1E293B),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0,3))],
                  ),
                  child: Column(
                    children: const [
                      Text(
                        'Genera tu modelo con Inteligencia Artificial',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Color(0xFF1E293B)),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Toma o selecciona una fotografía del plano para generar su versión 3D automáticamente.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Imagen seleccionada
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0,3))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: _selectedImage != null
                      ? Image.file(_selectedImage!, height: 240, fit: BoxFit.cover)
                      : Image.asset('assets/images/imagen.png', height: 240, fit: BoxFit.cover),
                  ),
                ),

                const SizedBox(height: 30),

                // Botones
                if (_isLoading)
                  const CircularProgressIndicator(color: Color(0xFFDC5F00))
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _circleButton(Icons.photo, const Color(0xFF9CA3AF), () => _pickImage(ImageSource.gallery)),
                      _circleButton(Icons.camera_alt, const Color(0xFFDC5F00), () => _pickImage(ImageSource.camera)),
                      _circleButton(Icons.cloud_upload, const Color(0xFF1E293B), _uploadPlan),
                    ],
                  ),

                const SizedBox(height: 30),

                // Si hay URL, mostrar visor 3D + controles
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _glbUrl != null
                      ? Column(
                          key: ValueKey('viewer_${_glbUrl}'),
                          children: [
                            // Controles (copiar / abrir)
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6, offset: const Offset(0,3))]),
                                    child: TextField(
                                      controller: TextEditingController(text: _glbUrl),
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        labelText: 'URL del modelo GLB',
                                        labelStyle: const TextStyle(color: Color(0xFF1E293B)),
                                        border: InputBorder.none,
                                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  children: [
                                    IconButton(
                                      onPressed: () => _copyToClipboard(_glbUrl!, label: '📋 Enlace copiado'),
                                      icon: const Icon(Icons.copy, color: Color(0xFFDC5F00)),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        // abrir visor en una nueva ruta full screen si quieres
                                        Navigator.of(context).push(MaterialPageRoute(builder: (_) => _FullScreenModelPage(modelUrl: _glbUrl!)));
                                      },
                                      icon: const Icon(Icons.open_in_full, color: Color(0xFF1E293B)),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            // Visor embebido
                            Container(
                              height: 360,
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8, offset: const Offset(0,4))]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(18),
                                child: ModelViewer(
                                  src: _glbUrl!,
                                  alt: "Modelo generado",
                                  ar: true,
                                  autoRotate: true,
                                  cameraControls: true,
                                  backgroundColor: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          key: const ValueKey('no_model'),
                          children: const [
                            SizedBox(height: 8),
                            Text('Tu modelo 3D aparecerá aquí después de generar.', style: TextStyle(color: Colors.black54)),
                          ],
                        ),
                ),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _circleButton(IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withOpacity(0.4), blurRadius: 10, offset: const Offset(0,5))],
        ),
        child: Icon(icon, color: Colors.white, size: 34),
      ),
    );
  }
}

// Página full-screen opcional para ver el modelo
class _FullScreenModelPage extends StatelessWidget {
  final String modelUrl;
  const _FullScreenModelPage({required this.modelUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Visor 3D'),
        backgroundColor: const Color(0xFFFFF8F0),
        iconTheme: const IconThemeData(color: Color(0xFF1E293B)),
      ),
      body: Center(
        child: ModelViewer(
          src: modelUrl,
          alt: "Modelo 3D Fullscreen",
          ar: true,
          autoRotate: true,
          cameraControls: true,
        ),
      ),
    );
  }
}
