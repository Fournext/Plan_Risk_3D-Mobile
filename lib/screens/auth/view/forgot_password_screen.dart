/* import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/auth/service/auth_controller.dart';
import 'package:mobile_plan_risk_3d/screens/auth/models/user_model.dart';
import 'package:mobile_plan_risk_3d/screens/widgets/input/custom_textfield.dart';

import '../../../../config/app_textstyles.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
              ),
              const SizedBox(height: 20),

              Text(
                'Restablecer Contraseña',
                style: AppTextStyle.withColor(
                  AppTextStyle.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Ingresa tu correo electrónico para restablecer tu contraseña',
                style: AppTextStyle.withColor(
                  AppTextStyle.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 40),

              CustomTextfield(
                label: 'Correo electrónico',
                prefixIcon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Ingresa tu correo';
                  if (!GetUtils.isEmail(v)) return 'Correo inválido';
                  return null;
                },
              ),
              const SizedBox(height: 24),

             SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      //final user = UserModel(name: '' , email: _emailController.text.trim());
      /// corregir por que lleva name y passwoed vacio , buscar otra solucion 
      /// por que en el modelo usermodel estan los 3 campos obligatorios
      /// recisar modelo usermodel... tarea pa seba
     final user = UserModel(name: '', email: _emailController.text.trim(), password: '');

      _handlePasswordReset(user, context);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(
      'Enviar enlace de restablecimiento',
      style: AppTextStyle.withColor(AppTextStyle.buttonMedium, Colors.white),
    ),
  ),
),

            ],
          ),
        ),
      ),
    );
  }

 void _handlePasswordReset(UserModel user, BuildContext context) {
  if (!GetUtils.isEmail(user.email)) {
    Get.snackbar('Error', 'Correo inválido');
    return;
  }

  final auth = Get.find<AuthController>();
  auth.sendResetLink(user.email); // ✅ aquí lo usas

  // Mostrar mensaje de éxito visual
  Get.dialog(
    AlertDialog(
      title: Text('Revisa tu correo', style: AppTextStyle.h3),
      content: Text(
        'Hemos enviado instrucciones de recuperación a ${user.email}.',
        style: AppTextStyle.bodyMedium,
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text(
            'Aceptar',
            style: AppTextStyle.withColor(
              AppTextStyle.buttonMedium,
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      ],
    ),
  );
}

}
 */