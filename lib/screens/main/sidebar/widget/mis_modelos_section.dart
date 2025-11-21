import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_plan_risk_3d/screens/auth/controller/model_controller.dart';
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/modelo_detalle_page.dart';

import '../../../../const/app_constants.dart';

class MisModelosSection extends StatefulWidget {
  const MisModelosSection({super.key});

  @override
  State<MisModelosSection> createState() => _MisModelosSectionState();
}

class _MisModelosSectionState extends State<MisModelosSection>
    with AutomaticKeepAliveClientMixin {

  bool _loading = true;
  List<dynamic> _modelos = [];

  final baseUrl = '${AppConstants.baseUrl}api/set_plan/lista_modelos/';

  final modelCtrl = Get.find<ModelController>(); // 🔥 controlador global

  @override
  void initState() {
    super.initState();

    // cargar lista inicial
    _fetchModelos();

    // 🔥 cuando IA genera un modelo → refrescar
    ever(modelCtrl.mustRefresh, (value) {
      if (value == true) {
        _fetchModelos();
        modelCtrl.consumed();
      }
    });
  }

  @override
  bool get wantKeepAlive => true;

  Future<void> _fetchModelos() async {
    setState(() => _loading = true);

    try {
      final auth = Get.find<AuthController>();
      final token = auth.getToken();

      if (token == null) return;

      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

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
    super.build(context);

    final theme = Theme.of(context);

    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_modelos.isEmpty) {
      return const Center(child: Text("No tienes modelos generados aún 🧐"));
    }

    return RefreshIndicator(
      onRefresh: _fetchModelos,
      child: Column(
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
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _modelos.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 200,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemBuilder: (_, i) {
              final m = _modelos[i];
              final imageUrl = "${AppConstants.baseUrlPacht}${m['plan_image']}";

              return InkWell(
                onTap: () async {
                  await Get.to(() => ModeloDetallePage(modelo: m));
                  _fetchModelos(); // 🔥 actualizar al volver
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(14),
                          ),
                          child: Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("ID #${m['id']}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            Text(
                              "Creado: ${m['created_at'].toString().split('T').first}",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
