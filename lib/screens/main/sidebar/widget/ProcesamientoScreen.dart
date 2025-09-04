import 'package:flutter/material.dart';

class ProcesamientoScreen extends StatelessWidget {
  final String? imagePath;

  const ProcesamientoScreen({super.key, this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF083D77),
        title: const Text("Generando Modelo 3D"),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 18),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Image.asset(
                imagePath!,
                height: 180,
              ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 20),
            const Text(
              "Procesando foto para generar modelo 3D...",
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
