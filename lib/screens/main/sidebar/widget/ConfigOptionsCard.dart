import 'package:flutter/material.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/plan_premiun.dart';

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
    const AnimatedOption(icon: Icons.dark_mode, label: 'Modo Oscuro'),
    const Divider(height: 1),
    AnimatedOption(
      icon: Icons.notifications,
      label: 'Plan Premium',
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PlanPremiumScreen()),
        );
      },
    ),
    const Divider(height: 1),
    const AnimatedOption(icon: Icons.language, label: 'Idioma'),
    const Divider(height: 1),
    const AnimatedOption(
      icon: Icons.help_outline,
      label: 'Ayuda & Soporte',
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
   final VoidCallback? onTap; // 

  const AnimatedOption({super.key, required this.icon, required this.label, this.onTap});

  @override
  State<AnimatedOption> createState() => _AnimatedOptionState();
}

class _AnimatedOptionState extends State<AnimatedOption> {
  double _scale = 1.0;

  void _onTapDown(_) => setState(() => _scale = 0.97);
  void _onTapUp(_) => setState(() => _scale = 1.0);

  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF3B82F6);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: () => setState(() => _scale = 1.0),
    onTap: () {
  setState(() => _scale = 1.0);
  widget.onTap?.call(); // Llama a la función si fue pasada
},

      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 100),
        child: Container(
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
                  ),
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
