import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/config/theme_controller.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/plan_premiun.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/soporte_ayuda.dart';

class ConfigOptionsCard extends StatelessWidget {
  const ConfigOptionsCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const primaryColor = Color(0xFF2563EB); // Azul principal
    const darkTextColor = Color(0xFF1E293B);

    return Stack(
      children: [
        // Fondo animado con gradiente suave
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(seconds: 2),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF0F4FF), Color(0xFFFFFFFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        // Contenido principal
        Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado
              Row(
                children: [
                  const Icon(Icons.settings, size: 30, color: primaryColor),
                  const SizedBox(width: 10),
                  Text(
                    'Configuración',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: darkTextColor,
                      fontSize: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Tarjeta con opciones
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      spreadRadius: 2,
                      color: Colors.black.withOpacity(0.06),
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Divider(height: 1),
                    const Divider(height: 1),
                    AnimatedOption(
                      icon: Icons.help_outline,
                      label: 'Ayuda & Soporte',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const HelpSupportScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Pie de versión
              Center(
                child: Text(
                  'Versión 1.0.0',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class AnimatedOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const AnimatedOption({
    super.key,
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  State<AnimatedOption> createState() => _AnimatedOptionState();
}

class _AnimatedOptionState extends State<AnimatedOption>
    with SingleTickerProviderStateMixin {
  double _scale = 1.0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF3B82F6); // azul moderno
    const hoverColor = Color(0xFFF0F4FF); // azul claro de toque

    return FadeTransition(
      opacity: _fadeAnimation,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: () => setState(() => _scale = 1.0),
        onTap: () {
          setState(() => _scale = 1.0);
          widget.onTap?.call();
        },
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          child: Container(
            decoration: BoxDecoration(
              color: hoverColor,
              borderRadius: BorderRadius.circular(10),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(widget.icon, color: iconColor, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    widget.label,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFF1E293B),
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
