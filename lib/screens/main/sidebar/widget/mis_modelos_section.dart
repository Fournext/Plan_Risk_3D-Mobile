import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/modelo_detalle_page.dart';

class MisModelosSection extends StatefulWidget {
  const MisModelosSection({super.key});

  @override
  State<MisModelosSection> createState() => _MisModelosSectionState();
}

class _MisModelosSectionState extends State<MisModelosSection> {
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

      final res = await http.get(Uri.parse(baseUrl), headers: {
        'Authorization': 'Bearer $token',
      });

      if (res.statusCode == 200) {
        final data = json.decode(res.body) as List;
        setState(() {
          _modelos = data;
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint('❌ Error: $e');
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: CircularProgressIndicator(),
      ));
    }

    if (_modelos.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Text('No tienes modelos generados aún 🧐'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Mis Modelos',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          itemCount: _modelos.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisExtent: 200,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (_, i) {
            final m = _modelos[i];
            final imageUrl = "http://10.0.2.2:8000${m['plan_image']}";
            return InkWell(
              onTap: () => Get.to(() => ModeloDetallePage(modelo: m)),
              borderRadius: BorderRadius.circular(14),
              child: Ink(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
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
                    Expanded(
                      child: ClipRRect(
                        borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14)),
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (_, __, ___) => const Icon(
                              Icons.broken_image, size: 40, color: Colors.grey),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("ID #${m['id']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14)),
                          Text(
                            "Creado: ${m['created_at'].toString().split('T').first}",
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
