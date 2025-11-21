import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F4),
      body: Stack(
        children: [
          // ===== Fondo con gradiente =====
          Container(
            height: 260,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFDC5F00), Color(0xFFFFE5C4)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),

          // ===== Contenido =====
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ===== Título =====
                  const Text(
                    'Mi Perfil',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 24,
                      letterSpacing: 0.5,
                    ),
                  ),

                  const SizedBox(height: 26),

                  // ===== Avatar + Tarjeta blanca =====
                  Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      // Fondo de tarjeta
                      Container(
                        margin: const EdgeInsets.only(top: 60),
                        padding: const EdgeInsets.fromLTRB(20, 80, 20, 26),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // ==== Datos de usuario ====
                            Obx(() {
                              final u = auth.currentUser.value;
                              final name = u?.nombre ?? 'Usuario';
                              final email =
                                  u?.email ?? 'correo@no-disponible.com';

                              return Column(
                                children: [
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    email,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              );
                            }),

                            const SizedBox(height: 30),

                            // ==== Botones ====
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () =>
                                        _showEditDialog(context, auth),
                                    icon: const Icon(
                                      Icons.edit,
                                      color: Color(0xFFDC5F00),
                                    ),
                                    label: const Text(
                                      'Editar',
                                      style: TextStyle(
                                        color: Color(0xFFDC5F00),
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFFDC5F00),
                                        width: 1.6,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => auth.logout(),
                                    icon: const Icon(
                                      Icons.logout,
                                      color: Colors.white,
                                    ),
                                    label: const Text(
                                      'Salir',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFDC5F00),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 6,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 30),

                            // ==== Mensaje de seguridad ====
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 14,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF5EE),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: const Color(0xFFDC5F00),
                                  width: 1.2,
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Icon(
                                    Icons.shield_rounded,
                                    color: Color(0xFFDC5F00),
                                  ),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      'Tus datos están protegidos con seguridad avanzada 🔒',
                                      style: TextStyle(
                                        fontSize: 13.5,
                                        color: Color(0xFF1E293B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // ==== Avatar circular con borde ====
                      Positioned(
                        top: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 4),
                          ),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundColor: const Color(
                              0xFFDC5F00,
                            ).withOpacity(.2),
                            child: ClipOval(
                              child: Image.asset(
                                'assets/images/avatar.png',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==== Modal para editar perfil ====
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
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Center(
                child: Text(
                  'Editar Perfil',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              _FancyField(
                controller: nameCtrl,
                label: 'Nombre',
                icon: Icons.person,
              ),
              const SizedBox(height: 12),
              _FancyField(
                controller: emailCtrl,
                label: 'Correo',
                icon: Icons.email,
              ),
              const SizedBox(height: 12),
              _FancyField(
                controller: passCtrl,
                label: 'Contraseña nueva',
                icon: Icons.lock,
              ),
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
                  backgroundColor: const Color(0xFFDC5F00),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Guardar cambios',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// === Campo reutilizable ===
class _FancyField extends StatelessWidget {
  const _FancyField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFFDC5F00)),
        labelText: label,
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFDC5F00), width: 1.5),
        ),
      ),
    );
  }
}
