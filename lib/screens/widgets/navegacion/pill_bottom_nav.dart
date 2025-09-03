import 'package:flutter/material.dart';

class PillBottomNav extends StatelessWidget {
  const PillBottomNav({
    super.key,
    required this.index,
    required this.onTap,
  });

  final int index;
  final void Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: Material(
          color: theme.colorScheme.surface,
          elevation: 10,
          shadowColor: Colors.black12,
          borderRadius: BorderRadius.circular(28),
          child: Container(
            height: 68,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NavBtnAnimated(
                  isActive: index == 0,
                  activeColor: const Color(0xFFFF3859),
                  icon: Icons.note_alt_rounded,
                  onTap: () => onTap(0),
                ),
                _NavBtnAnimated(
                  isActive: index == 1,
                  activeColor: const Color(0xFF17153A),
                  icon: Icons.show_chart_rounded,
                  onTap: () => onTap(1),
                ),
                _NavBtnAnimated.filled(
                  isActive: index == 2,
                  fillColor: const Color(0xFF7C4DFF),
                  icon: Icons.person_rounded,
                  onTap: () => onTap(2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBtnAnimated extends StatelessWidget {
  const _NavBtnAnimated({
    required this.isActive,
    required this.icon,
    required this.onTap,
    required this.activeColor,
  })  : filled = false,
        fillColor = null;

  const _NavBtnAnimated.filled({
    required this.isActive,
    required this.icon,
    required this.onTap,
    required this.fillColor,
  })  : filled = true,
        activeColor = null;

  final bool isActive;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;
  final Color? activeColor;
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    final duration = const Duration(milliseconds: 300);
    final iconColor = filled
        ? Colors.white
        : (isActive ? activeColor! : Colors.grey.shade500);

    return AnimatedScale(
      duration: duration,
      scale: isActive ? 1.15 : 1.0,
      curve: Curves.easeOutBack,
      child: AnimatedOpacity(
        duration: duration,
        opacity: isActive ? 1 : 0.8,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: AnimatedContainer(
            duration: duration,
            curve: Curves.easeOut,
            height: 48,
            width: filled ? 48 : 44,
            decoration: BoxDecoration(
              color: filled
                  ? (isActive
                      ? fillColor!
                      : fillColor!.withOpacity(0.85))
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(24),
              boxShadow: filled && isActive
                  ? [
                      BoxShadow(
                        color: fillColor!.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 22, color: iconColor),
          ),
        ),
      ),
    );
  }
}
