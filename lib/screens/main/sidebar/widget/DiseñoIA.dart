import 'package:flutter/material.dart';
import 'package:mobile_plan_risk_3d/screens/main/sidebar/widget/ProcesamientoScreen.dart';

class IADisenoScreen extends StatefulWidget {
  const IADisenoScreen({super.key});

  @override
  State<IADisenoScreen> createState() => _IADisenoScreenState();
}

class _IADisenoScreenState extends State<IADisenoScreen>
    with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() => _opacity = 1.0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF083D77),
        title: const Text('IA Diseño'),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w500,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 30),
              const Text(
                'Tomar fotografía',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF083D77),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Captura una foto para generar un modelo 3D',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.hardEdge,
                child: Image.asset(
                  'assets/images/imagen.png',
                  fit: BoxFit.cover,
                  height: 220,
                ),
              ),

              /// Aquí aumentamos el espacio entre la imagen y el botón
              const SizedBox(height: 50),

             GestureDetector(
  onTap: () async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('📸 Capturando fotografía...')),
    );

    await Future.delayed(const Duration(milliseconds: 500));

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const ProcesamientoScreen(
          imagePath: 'assets/images/imagen.png',
        ),
      ),
    );
  },
  child: Container(
    width: 80,
    height: 80,
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      shape: BoxShape.circle,
      boxShadow: const [
        BoxShadow(
          color: Colors.orangeAccent,
          blurRadius: 10,
          offset: Offset(0, 5),
        )
      ],
    ),
    child: const Icon(
      Icons.camera_alt,
      color: Colors.white,
      size: 36,
    ),
  ),
),


              /// un poco espacion para boton se vea bien
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
