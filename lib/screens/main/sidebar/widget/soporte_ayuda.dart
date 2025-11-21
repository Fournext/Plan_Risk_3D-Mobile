import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  // ====== Abrir URL ======
  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "No se pudo abrir: $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F8FE),
      appBar: AppBar(
        elevation: 1,
        backgroundColor: const Color(0xFF083D77),
        title: const Text(
          "Ayuda & Soporte",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const SizedBox(height: 8),

            // =================== HEADER ===================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "Centro de Ayuda",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF083D77),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Encuentra respuestas rápidas o conéctate con nuestro sitio web.",
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // ================= TITULO FAQ =================
            const Text(
              'Preguntas Frecuentes',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF083D77),
              ),
            ),
            const SizedBox(height: 10),

            const FAQItem(
              question: '¿Cómo genero un modelo 3D?',
              answer:
                  'Desde el menú principal, selecciona “IA Diseño”, toma una fotografía del plano y espera el procesamiento.',
            ),
            const FAQItem(
              question: '¿Puedo ver mis modelos después?',
              answer:
                  'Sí. Todos tus modelos quedan guardados en “Mis Modelos” dentro del Dashboard.',
            ),
            const FAQItem(
              question: '¿Qué incluye el Plan Premium?',
              answer:
                  'Incluye modelos ilimitados, render HD, análisis IA avanzado y optimización de planos.',
            ),

            const SizedBox(height: 30),

            // =================== TARJETA CON ENLACE ===================
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Conéctate a nuestro sitio web",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF083D77),
                    ),
                  ),
                  const SizedBox(height: 12),

                  InkWell(
                    onTap: () => _openUrl("https://front-sw1.fournext.me/login"),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF2FB),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.link, size: 26, color: Color(0xFF083D77)),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Abrir front-sw1.fournext.me",
                              style: TextStyle(
                                fontSize: 15,
                                color: Color(0xFF083D77),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// ========================= FAQ ITEM =========================
class FAQItem extends StatelessWidget {
  final String question;
  final String answer;

  const FAQItem({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          question,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              answer,
              style: const TextStyle(color: Colors.black87, height: 1.4),
            ),
          ),
        ],
      ),
    );
  }
}
