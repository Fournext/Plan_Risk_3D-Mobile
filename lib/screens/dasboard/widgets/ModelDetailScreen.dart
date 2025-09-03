import 'package:flutter/material.dart';
import 'package:mobile_plan_risk_3d/screens/dasboard/models/modeldetail.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import 'package:mobile_plan_risk_3d/screens/widgets/navegacion/pill_bottom_nav.dart';

class ModelDetailScreen extends StatefulWidget {
  const ModelDetailScreen({
    super.key,
    required this.model,
  });

  final ModelDetail model;

  @override
  State<ModelDetailScreen> createState() => _ModelDetailScreenState();
}

class _ModelDetailScreenState extends State<ModelDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeIn;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onBottomTap(int i) => setState(() => _navIndex = i);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final model = widget.model;

    return Scaffold(
      backgroundColor: const Color(0xFFEFF6FF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(model.title, style: const TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FadeTransition(
        opacity: _fadeIn,
             child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Cabecera con título y fecha
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    model.title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model.dateText,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Modelo 3D visualizado
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
                child: Material(
                  elevation: 10,
                  borderRadius: BorderRadius.circular(24),
                  color: Colors.white,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: ModelViewer(
                      key: ValueKey(model.glbUrl),
                      src: model.glbUrl,
                      alt: 'Modelo 3D',
                      ar: false,
                      autoRotate: true,
                      cameraControls: true,
                      backgroundColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: PillBottomNav(index: _navIndex, onTap: _onBottomTap),
    );
  }
}