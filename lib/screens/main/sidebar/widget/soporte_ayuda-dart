import 'package:flutter/material.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FE),
      appBar: AppBar(
        backgroundColor: const Color(0xFF083D77),
        title: const Text("Ayuda & Soporte"),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 16),

            // FAQ
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const FAQItem(
              question: '¿Cómo genero un modelo 3D?',
              answer: 'Desde el menú principal, selecciona “IA Diseño” y toma una fotografía del plano.',
            ),
            const FAQItem(
              question: '¿Qué incluye el Plan Premium?',
              answer: 'Incluye modelos ilimitados, renderizado HD, análisis IA y diseño interior.',
            ),
            const FAQItem(
              question: '¿Cómo contacto al soporte técnico?',
              answer: 'Puedes escribirnos desde la sección inferior de esta página o enviarnos un correo.', 
            ),

            const SizedBox(height: 32),

            // Contacto directo
            const Text(
              '¿Aún necesitas ayuda?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                // Acción simulada
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('📧 Abriendo contacto por email...')),
                );
              },
              icon: const Icon(Icons.email_outlined),
              label: const Text('Enviar un correo a soporte'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'También puedes visitar nuestro centro de ayuda en línea para ver guías paso a paso.',
              style: TextStyle(color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      tilePadding: const EdgeInsets.symmetric(horizontal: 8),
      childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            answer,
            style: TextStyle(color: Colors.grey[800]),
          ),
        ),
      ],
    );
  }
}
