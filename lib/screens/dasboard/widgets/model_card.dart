import 'package:flutter/material.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/model3d_model.dart';

class ModelCard extends StatelessWidget {
  const ModelCard({
    super.key,
    required this.model,
    required this.onTap,
  });

  final Model3D model;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              blurRadius: 18,
              offset: const Offset(0, 8),
              color: Colors.black.withOpacity(0.07),
            ),
          ],
        ),
        child: Row(
          children: [
            // Imagen o ícono del modelo
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Container(
                height: 64,
                width: 64,
                color: theme.primaryColor.withOpacity(.12),
                child: model.thumbnailAsset != null
                    ? Image.asset(model.thumbnailAsset!, fit: BoxFit.cover)
                    : Icon(Icons.domain, color: theme.primaryColor, size: 30),
              ),
            ),
            const SizedBox(width: 14),
            // Título y fecha
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    model.date,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 26),
          ],
        ),
      ),
    );
  }
}
