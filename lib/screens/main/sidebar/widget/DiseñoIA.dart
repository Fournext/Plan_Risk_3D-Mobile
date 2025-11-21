import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:mobile_plan_risk_3d/screens/auth/controller/model_controller.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../../../../const/app_constants.dart';

/// Pantalla principal para generar modelos 3D mediante IA.
/// 
/// Permite:
/// - Tomar foto o seleccionar imagen.
/// - Enviar el plano al backend.
/// - Mostrar el modelo GLB generado.
/// - Notificar al `ModelController` para refrescar listas.
class IADisenoScreen extends StatefulWidget {
  const IADisenoScreen({super.key});

  @override
  State<IADisenoScreen> createState() => _IADisenoScreenState();
}

class _IADisenoScreenState extends State<IADisenoScreen>
    with SingleTickerProviderStateMixin {

  /// URL final del archivo GLB generado.
  String? _glbUrl;

  /// Animación de opacidad inicial.
  double _opacity = 0.0;

  /// Imagen seleccionada por el usuario.
  File? _selectedImage;

  /// Bandera para mostrar loader mientras se genera el modelo.
  bool _isLoading = false;

  /// Persistencia local con GetStorage.
  final _box = GetStorage();

  /// Endpoint para subir el plano.
  final String baseUrl = '${AppConstants.baseUrl}api/set_plan/plans/';

  /// Inicialización + animación de opacity.
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
  }

  /// Permite al usuario seleccionar imagen desde cámara o galería.
  ///
  /// [source] → ImageSource.camera o ImageSource.gallery.
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: source, imageQuality: 85);

    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  /// Envía la imagen al backend para generar el modelo 3D.
  ///
  /// - Valida si hay imagen.
  /// - Envia petición Multipart.
  /// - Extrae la URL del modelo generado.
  /// - Notifica a `ModelController` para refrescar listas.
  Future<void> _uploadPlan() async {
    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Primero selecciona o toma una foto')),
      );
      return;
    }

    final user = _box.read('usuario');
    if (user == null || user['id'] == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Usuario no encontrado')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _glbUrl = null;
    });

    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl))
        ..fields['usuario'] = user['id'].toString()
        ..files.add(
          await http.MultipartFile.fromPath('plan_file', _selectedImage!.path),
        );

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResp = jsonDecode(responseBody);

        final dynamic glbField = jsonResp['glb_model'] ??
            jsonResp['glb'] ??
            jsonResp['model_url'];

        if (glbField != null && glbField is String && glbField.isNotEmpty) {
          final fullUrl = glbField.startsWith('http')
              ? glbField
              : '${AppConstants.baseUrlPacht}$glbField';

          setState(() => _glbUrl = fullUrl);

          /// Notifica para refrescar la lista de modelos
          Get.find<ModelController>().notifyRefresh();

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Modelo generado correctamente')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al subir: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Copia texto al portapapeles (e.g., URL del modelo).
  Future<void> _copyToClipboard(String text, {String? label}) async {
    await Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(label ?? '📋 Enlace copiado')),
    );
  }

  /// Construye la interfaz visual de la pantalla.
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

      /// Animación suave al cargar UI
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                /// Sección informativa superior
                _buildHeader(),

                const SizedBox(height: 30),

                /// Imagen seleccionada o placeholder
                _buildSelectedImage(),

                const SizedBox(height: 30),

                /// Botones para seleccionar/crear modelo
                _isLoading
                    ? const CircularProgressIndicator(color: Color(0xFFDC5F00))
                    : _buildActionButtons(),

                const SizedBox(height: 30),

                /// Render 3D si hay modelo generado
                _buildViewerSection(),

                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Construye la tarjeta informativa superior.
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: const Column(
        children: [
          Text(
            'Genera tu modelo con Inteligencia Artificial',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Toma o selecciona una fotografía del plano para generar su versión 3D automáticamente.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 15, color: Colors.black54, height: 1.4),
          ),
        ],
      ),
    );
  }

  /// Muestra la imagen seleccionada o un placeholder.
  Widget _buildSelectedImage() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
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
        child: _selectedImage != null
            ? Image.file(_selectedImage!, height: 240, fit: BoxFit.cover)
            : Image.asset(
                'assets/images/imagen.png',
                height: 240,
                fit: BoxFit.cover,
              ),
      ),
    );
  }

  /// Botones para elegir imagen o subir modelo.
  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _circleButton(Icons.photo, const Color(0xFF9CA3AF),
            () => _pickImage(ImageSource.gallery)),
        _circleButton(Icons.camera_alt, const Color(0xFFDC5F00),
            () => _pickImage(ImageSource.camera)),
        _circleButton(
            Icons.cloud_upload, const Color(0xFF1E293B), _uploadPlan),
      ],
    );
  }

  /// Contenedor con visor 3D y controles (copiar, fullscreen).
  Widget _buildViewerSection() {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      child: _glbUrl != null
          ? Column(
              key: ValueKey('viewer_${_glbUrl}'),
              children: [
                _buildViewerControls(),
                const SizedBox(height: 14),
                _buildModelViewer(),
              ],
            )
          : const Column(
              key: ValueKey('no_model'),
              children: [
                SizedBox(height: 8),
                Text(
                  'Tu modelo 3D aparecerá aquí después de generar.',
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
    );
  }

  /// Construye los controles para copiar URL y abrir fullscreen.
  Widget _buildViewerControls() {
    return Row(
      children: [
        Expanded(
          child: Container(
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
              controller: TextEditingController(text: _glbUrl),
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'URL del modelo GLB',
                labelStyle: TextStyle(color: Color(0xFF1E293B)),
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            IconButton(
              onPressed: () =>
                  _copyToClipboard(_glbUrl!, label: '📋 Enlace copiado'),
              icon: const Icon(Icons.copy, color: Color(0xFFDC5F00)),
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => _FullScreenModelPage(modelUrl: _glbUrl!),
                  ),
                );
              },
              icon: const Icon(Icons.open_in_full, color: Color(0xFF1E293B)),
            ),
          ],
        ),
      ],
    );
  }

  /// Construye el visor 3D en pantalla.
  Widget _buildModelViewer() {
    return Container(
      height: 360,
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
    );
  }

  /// Crea un botón circular reutilizable.
  Widget _circleButton(
      IconData icon, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.4),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 34),
      ),
    );
  }
}

/// Pantalla fullscreen para visualizar un modelo GLB.
class _FullScreenModelPage extends StatelessWidget {
  /// URL del modelo 3D
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
