import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/main/perfil/model/model_item.dart';
import '../../auth/service/auth_controller.dart';
import '../../../routes/routes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final auth = Get.find<AuthController>();

    const userName = 'Carlos L\u00f3pez';
    const userEmail = 'carlos.lopez@email.com';

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
              TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 600),
                tween: Tween(begin: 0.85, end: 1),
                curve: Curves.easeOutBack,
                builder: (_, v, child) => Transform.scale(scale: v, child: child),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primary.withOpacity(.15),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/avatar.png',
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.person, size: 60, color: theme.primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                userName,
                style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              const SizedBox(height: 4),
              Text(
                userEmail,
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600], fontSize: 15),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Get.snackbar('Editar perfil', 'Pr\u00f3ximamente'),
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
                      onPressed: () {
                        auth.logout();
                        Get.offAllNamed(AppRoutes.signin);
                      },
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
                child: Text(
                  'Mis Modelos',
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                ),
              ),
              const SizedBox(height: 16),
              GridView.builder(
                itemCount: models.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 160,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
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
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, 6),
              color: Colors.black.withOpacity(0.06),
            ),
          ],
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
                      item.asset,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(Icons.view_in_ar, size: 36, color: theme.primaryColor),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
