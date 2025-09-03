import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_plan_risk_3d/screens/auth/models/user_model.dart';
import 'package:mobile_plan_risk_3d/screens/widgets/input/custom_textfield.dart';

import '../../../../config/app_textstyles.dart';
import '../service/auth_controller.dart';
import '../../../routes/routes.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

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
                'Crear Cuenta',
                style: AppTextStyle.withColor(
                  AppTextStyle.h1,
                  Theme.of(context).textTheme.bodyLarge!.color!,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Regístrate para comenzar',
                style: AppTextStyle.withColor(
                  AppTextStyle.bodyLarge,
                  isDark ? Colors.grey[400]! : Colors.grey[600]!,
                ),
              ),
              const SizedBox(height: 40),

              CustomTextfield(
                label: 'Nombre completo',
                prefixIcon: Icons.person_outline,
                keyboardType: TextInputType.name,
                controller: _nameController,
                validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: 16),

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
                prefixIcon: Icons.lock_outlined,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                controller: _passwordController,
                validator: (v) => (v == null || v.isEmpty) ? 'Ingresa tu contraseña' : null,
              ),
              const SizedBox(height: 16),

              CustomTextfield(
                label: 'Confirmar contraseña',
                prefixIcon: Icons.lock_outlined,
                keyboardType: TextInputType.visiblePassword,
                isPassword: true,
                controller: _confirmPasswordController,
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Confirma tu contraseña';
                  if (v != _passwordController.text) return 'Las contraseñas no coinciden';
                  return null;
                },
              ),
              const SizedBox(height: 24),

            SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () {
      final user = UserModel(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      Get.find<AuthController>().register(user);
      Get.offAllNamed(AppRoutes.home);
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Theme.of(context).primaryColor,
      padding: const EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    child: Text(
      'Registrarse',
      style: AppTextStyle.withColor(AppTextStyle.buttonMedium, Colors.white),
    ),
  ),
),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '¿Ya tienes una cuenta? ',
                    style: AppTextStyle.withColor(
                      AppTextStyle.bodyMedium,
                      isDark ? Colors.grey[400]! : Colors.grey[600]!,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Get.offNamed(AppRoutes.signin),
                    child: Text(
                      'Iniciar sesión',
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
}
