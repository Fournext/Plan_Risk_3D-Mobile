import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/modelo_detalle_page.dart';

class MyModeloPage extends StatefulWidget {
  const MyModeloPage({super.key});

  @override
  State<MyModeloPage> createState() => _MyModeloPageState();
}

class _MyModeloPageState extends State<MyModeloPage> {
  bool _loading = true;
  List<dynamic> _modelos = [];
  final baseUrl = 'http://10.0.2.2:8000/api/set_plan/lista_modelos/';

  @override
  void initState() {
    super.initState();
    _fetchModelos();
  }

  Future<void> _fetchModelos() async {
    try {
      final auth = Get.find<AuthController>();
      final token = auth.getToken();
      if (token == null) return;

      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        setState(() {
          _modelos = data;
          _loading = false;
        });
      } else {
        debugPrint("❌ Error ${res.statusCode}");
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint('❌ Error al obtener modelos: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FD),
      appBar: AppBar(
        title: const Text('Mis Modelos Generados'),
        backgroundColor: const Color(0xFF042940),
        centerTitle: true,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _modelos.isEmpty
              ? const Center(child: Text("Aún no tienes modelos generados 🧐"))
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _modelos.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 210,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemBuilder: (_, i) {
                    final m = _modelos[i];
                    final img = "http://10.0.2.2:8000${m['plan_image']}";
                    return InkWell(
                      onTap: () => Get.to(() => ModeloDetallePage(modelo: m)),
                      borderRadius: BorderRadius.circular(16),
                      child: Ink(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 5),
                            )
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(16)),
                                child: Image.network(
                                  img,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  errorBuilder: (_, __, ___) => const Icon(
                                    Icons.broken_image,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ID #${m['id']}",
                                      style: theme.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold)),
                                  Text(
                                      "Creado: ${m['created_at'].toString().split('T').first}",
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(color: Colors.grey[600])),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
