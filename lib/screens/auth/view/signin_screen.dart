import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/auth/models/user_model.dart';
import 'package:mobile_plan_risk_3d/screens/widgets/input/custom_textfield.dart';

import '../../../../config/app_textstyles.dart';
import '../service/auth_controller.dart';
import '../../../routes/routes.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              const SizedBox(height: 40),
              Text(
                '¡Bienvenido de nuevo!',
                style: AppTextStyle.withColor(
                  AppTextStyle.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Inicia sesión para continuar.',
                style: AppTextStyle.withColor(
                  AppTextStyle.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 32),

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
              const SizedBox(height: 16),

              CustomTextfield(
                label: 'Contraseña',
                prefixIcon: Icons.lock_open_outlined,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                controller: _passwordController,
                validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
              ),
              const SizedBox(height: 8),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.forgot),
                  child: Text(
                    '¿Olvidaste tu contraseña?',
                    style: AppTextStyle.withColor(
                      AppTextStyle.buttonMedium,
                      Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _handleSignIn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Iniciar sesión',
                    style: AppTextStyle.withColor(AppTextStyle.buttonMedium, Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 26),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "¿No tienes una cuenta?",
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.toNamed(AppRoutes.signup),
                    child: Text(
                      'Regístrate',
                      style: AppTextStyle.withColor(
                        AppTextStyle.buttonMedium,
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

 void _handleSignIn() {
  final user = UserModel(
    name: '', // No se necesita para login
    email: _emailController.text.trim(),
    password: _passwordController.text,
  );

  final auth = Get.find<AuthController>();
  auth.login(user); // pasamos el modelo
  Get.offAllNamed(AppRoutes.home);
}


}
