import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ necesario para copiar al portapapeles
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/ProcesamientoScreen.dart';

class IADisenoScreen extends StatefulWidget {
  const IADisenoScreen({super.key});

  @override
  State<IADisenoScreen> createState() => _IADisenoScreenState();
}

class _IADisenoScreenState extends State<IADisenoScreen>
    with SingleTickerProviderStateMixin {
  String? _glbUrl; // ✅ URL generada del modelo GLB
  double _opacity = 0.0;
  File? _selectedImage;
  bool _isLoading = false;
  final _box = GetStorage();

  final String baseUrl = 'http://10.0.2.2:8000/api/set_plan/plans/';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Usuario no encontrado')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      var request = http.MultipartRequest('POST', Uri.parse(baseUrl))
        ..fields['usuario'] = user['id'].toString()
        ..files.add(await http.MultipartFile.fromPath('plan_file', _selectedImage!.path));

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 201) {
        final regex = RegExp(r'"glb_model"\s*:\s*"([^"]+)"');
        final match = regex.firstMatch(responseBody);
        if (match != null) {
          final glbPath = match.group(1)!;
          final fullUrl = 'http://10.0.2.2:8000$glbPath';

          setState(() => _glbUrl = fullUrl);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('✅ Modelo generado correctamente')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('⚠️ No se encontró glb_model en la respuesta')),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF083D77),
        title: const Text('IA Diseño'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: SingleChildScrollView( // ✅ por si se extiende el contenido
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  'Tomar o seleccionar fotografía',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF083D77),
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Captura o selecciona una imagen para generar un modelo 3D',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 30),

                _selectedImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          _selectedImage!,
                          fit: BoxFit.cover,
                          height: 220,
                        ),
                      )
                    : Image.asset(
                        'assets/images/imagen.png',
                        fit: BoxFit.cover,
                        height: 220,
                      ),

                const SizedBox(height: 40),

                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _circleButton(Icons.photo, Colors.blue, () {
                        _pickImage(ImageSource.gallery);
                      }),
                      _circleButton(Icons.camera_alt, Colors.orange, () {
                        _pickImage(ImageSource.camera);
                      }),
                      _circleButton(Icons.cloud_upload, Colors.green, _uploadPlan),
                    ],
                  ),

                const SizedBox(height: 30),

                // ✅ Bloque para mostrar el enlace GLB
                if (_glbUrl != null) ...[
                  const SizedBox(height: 20),
                  TextField(
                    controller: TextEditingController(text: _glbUrl),
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'URL del modelo GLB',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.copy),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: _glbUrl!));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('📋 Enlace copiado')),
                          );
                        },
                      ),
                    ),
                  ),
                ],

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
          gradient: LinearGradient(
            colors: [color.withOpacity(0.8), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.6),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 36),
      ),
    );
  }
}
