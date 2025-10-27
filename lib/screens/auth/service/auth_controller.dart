// lib/screens/auth/service/auth_controller.dart  (o donde lo tengas)
import 'dart:convert';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_plan_risk_3d/api/auth_service.dart';
import 'package:mobile_plan_risk_3d/routes/routes.dart';

import '../models/user_model.dart';

class AuthController extends GetxController {
  late final AuthService _api;
  final _box = GetStorage();

  final isLoading = false.obs;
  final _isFirstTime = true.obs;
  final _isLogged = false.obs;

  bool get isFirstTime => _isFirstTime.value;
  bool get isLoggedIn => _isLogged.value || accessToken != null;

  // Usuario actual (para pantalla de perfil)
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  // inyección
  final String baseUrl;
  AuthController({required this.baseUrl});

  @override
  void onInit() {
    _api = AuthService(baseUrl);

    // flags
    _isFirstTime.value = _box.read('isFirstTime') ?? true;
    _isLogged.value = _box.read('isLoggedIn') ?? false;

    // restaurar usuario de storage si existe
    final raw = _box.read('usuario');
    if (raw != null) {
      // puede haberse guardado como Map o como String JSON
      if (raw is Map) {
        currentUser.value = UserModel.fromJson(Map<String, dynamic>.from(raw));
      } else if (raw is String) {
        currentUser.value = UserModel.fromJson(
          jsonDecode(raw) as Map<String, dynamic>,
        );
      }
    }

    super.onInit();
  }

  // ---------- storage helpers ----------
  String? get accessToken => _box.read('access');
  String? get refreshToken => _box.read('refresh');

  void setFirstTimeDone() {
    _isFirstTime.value = false;
    _box.write('isFirstTime', false);
  }

  // Guardar usuario en RAM + storage
  void _saveUser(dynamic usuarioJson) {
    if (usuarioJson == null) return;
    final map = Map<String, dynamic>.from(usuarioJson as Map);
    currentUser.value = UserModel.fromJson(map);
    _box.write('usuario', map); // guardamos como Map (GetStorage lo soporta)
  }

  // ---------- API ----------
  Future<void> register(UserModel user) async {
    try {
      isLoading.value = true;
      final res = await _api.register(user.toJsonRegistro());
      if (res.isOk) {
        // login automático
        await login(
          UserModel(nombre: '', email: user.email, password: user.password),
        );
      } else {
        Get.snackbar('Error', res.bodyString ?? 'Error al registrar');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login(UserModel user) async {
    try {
      isLoading.value = true;
      final res = await _api.login(user.toJsonLogin());

      if (res.isOk && res.body is Map) {
        final data = res.body as Map;

        _box.write('access', data['access']);
        _box.write('refresh', data['refresh']);
        _box.write('isLoggedIn', true);
        _isLogged.value = true;

        // usuario del backend → RAM + storage
        _saveUser(data['usuario']);

        Get.offAllNamed(AppRoutes.home);
        print('Login exitoso: ${res.bodyString}');
      } else {
        Get.snackbar('Credenciales', 'Email o contraseña inválidos');
        print('Login fallido: ${res.statusCode} - ${res.bodyString}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      final token = accessToken;
      if (token != null) {
        await _api.logout(token);
      }
    } catch (_) {
      // Silencio: el logout del backend es opcional.
    }
    // Limpia todo menos el flag de primera vez
    final firstTime = _box.read('isFirstTime') ?? false;
    await _box.erase();
    _box.write('isFirstTime', firstTime);

    currentUser.value = null;
    _isLogged.value = false;
    Get.offAllNamed(AppRoutes.signin);
  }

// -------------------updateprofile 

Future<void> updateProfile({String? nombre, String? password}) async {
  final token = accessToken;
  if (token == null) {
    Get.snackbar('Error', 'Token no encontrado, inicia sesión de nuevo');
    return;
  }

  final body = <String, dynamic>{};
  if (nombre != null) body['nombre'] = nombre;
  if (password != null) body['password'] = password;

  try {
    final res = await _api.updateProfile(token, body);

    if (res.isOk && res.body is Map) {
      final data = res.body as Map<String, dynamic>;
      currentUser.value = UserModel.fromJson(data);
      _box.write('usuario', data);
      Get.snackbar('Éxito', 'Perfil actualizado correctamente');
    } else {
      Get.snackbar('Error', 'No se pudo actualizar el perfil');
    }
  } catch (e) {
    Get.snackbar('Error', 'Error de conexión: $e');
  }
}
  // ---------- Helper para obtener token ----------
  String? getToken() {
    // Intenta leer el access token desde RAM o GetStorage
    final token = accessToken;
    if (token != null && token.isNotEmpty) {
      return token;
    }
    final stored = _box.read('access');
    if (stored != null && stored is String && stored.isNotEmpty) {
      return stored;
    }
    return null;
  }

}
