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
      width: 240,
      decoration: const BoxDecoration(
        color: Color(0xFF042940), // fondo azul oscuro
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Plan Risk 3D',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          _SidebarItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            isSelected: selectedIndex == 0,
            color: Colors.deepOrange,
            onTap: () => onItemSelected(0),
          ),
          _SidebarItem(
            icon: Icons.view_in_ar,
            label: 'Generate 3D',
            isSelected: selectedIndex == 1,
            color: Colors.greenAccent.shade700,
            onTap: () => onItemSelected(1),
          ),
          _SidebarItem(
            icon: Icons.warning,
            label: 'Mis Modelos ',
            isSelected: selectedIndex == 2,
            color: Colors.redAccent,
            onTap: () => onItemSelected(2),
          ),
          _SidebarItem(
            icon: Icons.psychology,
            label: 'IA Diseño',
            isSelected: selectedIndex == 3,
            color: Colors.purpleAccent,
            onTap: () => onItemSelected(3),
          ),
          _SidebarItem(
            icon: Icons.settings,
            label: 'Configuracion',
            isSelected: selectedIndex == 4,
            color: Colors.cyanAccent.shade700,
            onTap: () => onItemSelected(4),
          ),
          const Spacer(),
          const Divider(color: Colors.white24),
          _SidebarItem(
            icon: Icons.logout,
            label: 'Salir',
            isSelected: false,
            color: Colors.deepOrange,
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
  final Color color;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white10 : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            )
          ],
        ),
      ),
    );
  }
}
