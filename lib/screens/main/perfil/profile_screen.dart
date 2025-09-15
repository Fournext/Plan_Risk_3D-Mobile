import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';
import '../../../routes/routes.dart';
import 'model/model_item.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();

    final models = const [
      ModelItem(title: 'dewscripcion 1', asset: 'assets/images/model_office.png'),
      ModelItem(title: 'descripcion 2 ', asset: 'assets/images/model_risk.png'),
      ModelItem(title: 'dewscripcion 1', asset: 'assets/images/model_office.png'),
      ModelItem(title: 'descripcion 2 ', asset: 'assets/images/model_risk.png'),
      ModelItem(title: 'dewscripcion 1', asset: 'assets/images/model_office.png'),
      ModelItem(title: 'descripcion 2 ', asset: 'assets/images/model_risk.png'),
    ];

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

              // Nombre y email reales
              Obx(() {
                final u = auth.currentUser.value;
                final name = u?.nombre ?? 'Usuario';
                final email = u?.email ?? '...';
                return Column(
                  children: [
                    Text(name,
                        style: theme.textTheme.headlineSmall
                            ?.copyWith(fontWeight: FontWeight.bold, fontSize: 24)),
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
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
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
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 28),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Mis Modelos',
                    style: theme.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w800, fontSize: 20)),
              ),
              const SizedBox(height: 16),

              GridView.builder(
                itemCount: models.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, mainAxisExtent: 160,
                  mainAxisSpacing: 14, crossAxisSpacing: 14,
                ),
                itemBuilder: (_, i) {
                  final m = models[i];
                  return TweenAnimationBuilder<double>(
                    duration: Duration(milliseconds: 400 + i * 120),
                    tween: Tween(begin: 0.85, end: 1),
                    curve: Curves.easeOutBack,
                    builder: (_, v, child) => Transform.scale(scale: v, child: child),
                    child: _ModelCard(item: m, onTap: () => Get.toNamed(AppRoutes.viewer)),
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
    final nameCtrl  = TextEditingController(text: u?.nombre ?? '');
    final emailCtrl = TextEditingController(text: u?.email  ?? '');
    final passCtrl  = TextEditingController();

    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent, // para ver el blur/gradiente
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.46,
          minChildSize: 0.38,
          maxChildSize: 0.80,
          builder: (_, controller) => Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.white, Colors.grey.shade50],
                begin: Alignment.topCenter, end: Alignment.bottomCenter),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
              boxShadow: [BoxShadow(
                color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, -6),
              )],
            ),
            padding: EdgeInsets.only(
              left: 16, right: 16, top: 12,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            ),
            child: ListView(
              controller: controller,
              children: [
                Center(
                  child: Container(
                    width: 46, height: 5,
                    margin: const EdgeInsets.only(top: 6, bottom: 14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.person, color: theme.primaryColor),
                    ),
                    const SizedBox(width: 12),
                    Text('Editar perfil',
                        style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                  ],
                ),
                const SizedBox(height: 16),

                _FancyField(
                  controller: nameCtrl,
                  label: 'Nombre',
                  icon: Icons.badge_outlined,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),

                _FancyField(
                  controller: emailCtrl,
                  label: 'Correo',
                  icon: Icons.alternate_email,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),

                _FancyField(
                  controller: passCtrl,
                  label: 'Nueva contraseña (opcional)',
                  icon: Icons.lock_outline,
                  obscure: true,
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 18),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      auth.updateProfile(
                        nombre: nameCtrl.text.trim().isEmpty ? null : nameCtrl.text.trim(),
                        email : emailCtrl.text.trim().isEmpty ? null : emailCtrl.text.trim(),
                        password: passCtrl.text.isEmpty ? null : passCtrl.text,
                      );
                      Get.back();
                    },
                    icon: const Icon(Icons.save_outlined),
                    label: const Text('Guardar cambios'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ModelCard extends StatelessWidget {
  const _ModelCard({super.key, required this.item, required this.onTap});
  final ModelItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey.shade100],
            begin: Alignment.topLeft, end: Alignment.bottomRight),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(
            blurRadius: 12, offset: const Offset(0,6),
            color: Colors.black.withOpacity(0.06))],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    color: theme.primaryColor.withOpacity(.08),
                    child: Image.asset(
                      item.asset, fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                        Center(child: Icon(Icons.view_in_ar, size: 36, color: theme.primaryColor)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
            ],
          ),
        ),
      ),
    );
  }
}

/// Campo reutilizable con estilo
class _FancyField extends StatelessWidget {
  const _FancyField({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: theme.primaryColor),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: theme.primaryColor, width: 1.6),
        ),
      ),
    );
  }
}
