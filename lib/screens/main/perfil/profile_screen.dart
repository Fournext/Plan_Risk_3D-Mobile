import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';
import '../../../routes/routes.dart';
import 'model/model_item.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<ModelItem> _models = [];
  bool _isLoading = true;
  final baseUrl = 'http://10.0.2.2:8000/api/set_plan/lista_modelos/';

  @override
  void initState() {
    super.initState();
    _fetchModels();
  }

Future<void> _fetchModels() async {
  try {
    final auth = Get.find<AuthController>();
    final token = auth.getToken();
    if (token == null) return;

    final res = await http.get(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final data = json.decode(res.body) as List;
      setState(() {
        _models = data.map((e) => ModelItem.fromJson(e)).toList();
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
      debugPrint('Error al obtener modelos: ${res.statusCode}');
    }
  } catch (e) {
    debugPrint('❌ Error al cargar modelos: $e');
    setState(() => _isLoading = false);
  }
}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FD),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.85, end: 1),
                curve: Curves.easeOutBack,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary.withOpacity(.15),
                  child: ClipOval(
                    child: Image.asset('assets/images/avatar.png',
                        width: 90, height: 90, fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Nombre y correo
              Obx(() {
                final u = auth.currentUser.value;
                final name = u?.nombre ?? 'Usuario';
                final email = u?.email ?? '...';
                return Column(
                  children: [
                    Text(name,
                        style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 24)),
                    const SizedBox(height: 4),
                    Text(email,
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.grey[600], fontSize: 15)),
                  ],
                );
              }),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _showEditDialog(context, auth),
                      icon: const Icon(Icons.edit, size: 18),
                      label: const Text('Editar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => auth.logout(),
                      icon: const Icon(Icons.logout),
                      label: const Text('Salir'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Mis Modelos',
                    style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800, fontSize: 20)),
              ),
              const SizedBox(height: 16),

              if (_isLoading)
                const Center(child: CircularProgressIndicator())
              else if (_models.isEmpty)
                const Text('No hay modelos generados aún 🧐')
              else
                GridView.builder(
                  itemCount: _models.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 160,
                    mainAxisSpacing: 14,
                    crossAxisSpacing: 14,
                  ),
                  itemBuilder: (_, i) {
                    final m = _models[i];
                    return _ModelCard(
                      item: m,
                      onTap: () => Get.toNamed(AppRoutes.viewer, arguments: m.glbModel),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(BuildContext context, AuthController auth) {
    final u = auth.currentUser.value;
    final nameCtrl = TextEditingController(text: u?.nombre ?? '');
    final emailCtrl = TextEditingController(text: u?.email ?? '');
    final passCtrl = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
          ),
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 12),
              _FancyField(controller: nameCtrl, label: 'Nombre', icon: Icons.person),
              const SizedBox(height: 12),
              _FancyField(controller: emailCtrl, label: 'Correo', icon: Icons.email),
              const SizedBox(height: 12),
              _FancyField(controller: passCtrl, label: 'Contraseña nueva', icon: Icons.lock),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await auth.updateProfile(
                    nombre: nameCtrl.text.trim(),
                    password: passCtrl.text.trim(),
                  );
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor),
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// --------------------------------------------------------------------------

class _ModelCard extends StatelessWidget {
  const _ModelCard({required this.item, required this.onTap});
  final ModelItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = "http://10.0.2.2:8000${item.planImage}";
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported,
                        color: theme.primaryColor, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Text("ID #${item.id}",
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.bold)),
              Text("Creado: ${item.createdAt.split('T').first}",
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.grey[600])),
            ],
          ),
        ),
      ),
    );
  }
}

class _FancyField extends StatelessWidget {
  const _FancyField(
      {required this.controller, required this.label, required this.icon});
  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon),
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
