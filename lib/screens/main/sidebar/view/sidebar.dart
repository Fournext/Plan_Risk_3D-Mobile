import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Sidebar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onLogout;

  const Sidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 250,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFAF4EC), Color(0xFFF2EBDD)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(2, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header
          Row(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF042940),
                  shape: BoxShape.circle,
                ),
                padding: const EdgeInsets.all(10),
                child: const Icon(Icons.home_work_outlined,
                    color: Colors.white, size: 24),
              ),
              const SizedBox(width: 10),
              Text(
                "Plan Risk 3D",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF042940),
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // 🔹 Menu items
          _SidebarItem(
            icon: Icons.dashboard_rounded,
            label: 'Inicio',
            isSelected: selectedIndex == 0,
            accentColor: const Color(0xFFDB7F00),
            onTap: () => onItemSelected(0),
          ),
          _SidebarItem(
            icon: Icons.view_in_ar_rounded,
            label: 'Visualizador 3D',
            isSelected: selectedIndex == 1,
            accentColor: const Color(0xFF058C42),
            onTap: () => onItemSelected(1),
          ),
          _SidebarItem(
            icon: Icons.layers_rounded,
            label: 'Mi Perfil',
            isSelected: selectedIndex == 2,
            accentColor: const Color(0xFFDC3C3C),
            onTap: () => onItemSelected(2),
          ),
          _SidebarItem(
            icon: Icons.psychology_alt_rounded,
            label: 'IA Diseño',
            isSelected: selectedIndex == 3,
            accentColor: const Color(0xFF7C4DFF),
            onTap: () => onItemSelected(3),
          ),
          _SidebarItem(
            icon: Icons.settings_rounded,
            label: 'Configuración',
            isSelected: selectedIndex == 4,
            accentColor: const Color(0xFF0096C7),
            onTap: () => onItemSelected(4),
          ),

          const Spacer(),

          const Divider(thickness: 0.7, color: Color(0xFFB6B6B6)),
          const SizedBox(height: 10),

          // 🔹 Logout
          _SidebarItem(
            icon: Icons.logout_rounded,
            label: 'Salir',
            isSelected: false,
            accentColor: const Color(0xFFDC3C3C),
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color accentColor;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? accentColor.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: isSelected ? accentColor : Colors.grey[800], size: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? accentColor : Colors.grey[800],
                    fontWeight:
                        isSelected ? FontWeight.w700 : FontWeight.w500,
                    fontSize: 15,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.chevron_right_rounded,
                    color: Colors.black45, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
