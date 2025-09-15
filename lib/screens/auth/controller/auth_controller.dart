/* // lib/controllers/auth_controller.dart
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

  // Estado del usuario actual
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final String baseUrl; // inyección
  AuthController({required this.baseUrl});

  @override
  void onInit() {
    _api = AuthService(baseUrl);
    _isFirstTime.value = _box.read('isFirstTime') ?? true;
    _isLogged.value    = _box.read('isLoggedIn')  ?? false;
    super.onInit();
  }

  // ---------- storage helpers ----------
  String? get accessToken  => _box.read('access');
  String? get refreshToken => _box.read('refresh');

  void setFirstTimeDone() {
    _isFirstTime.value = false;
    _box.write('isFirstTime', false);
  }

  // ---------- API ----------
  Future<void> register(UserModel user) async {
    try {
      isLoading.value = true;
      final res = await _api.register(user.toJsonRegistro());
      if (res.isOk) {
        // login automático
        await login(UserModel(nombre: '', email: user.email, password: user.password));
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
        _box.write('access',  data['access']);
        _box.write('refresh', data['refresh']);
        _box.write('usuario', data['usuario']);
        _box.write('isLoggedIn', true);
        _isLogged.value = true;

        Get.offAllNamed(AppRoutes.home);
      } else {
        Get.snackbar('Credenciales', 'Email o contraseña inválidos');
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
    } catch (_) {}
    _box.erase();
    _isLogged.value = false;
    Get.offAllNamed(AppRoutes.signin);
  }
  Future<void> updateProfile({String? nombre, String? password}) async {
    final t = accessToken;
    if (t == null) return;
    final body = <String, dynamic>{};
    if (nombre != null && nombre.trim().isNotEmpty) body['nombre'] = nombre.trim();
    if (password != null && password.isNotEmpty) body['password'] = password;

    final res = await _api.updateMe(t, body);
    if (res.isOk && res.body is Map) {
      currentUser.value = UserModel.fromJson(res.body);
      Get.snackbar('Guardado', 'Perfil actualizado');
    } else {
      Get.snackbar('Error', res.bodyString ?? 'No se pudo actualizar');
    }
  }
}
 */