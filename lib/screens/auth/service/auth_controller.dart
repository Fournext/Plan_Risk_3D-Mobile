import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mobile_plan_risk_3d/screens/auth/models/user_model.dart';

class AuthController extends GetxController {
  final _storage = GetStorage();

  final RxBool _isFirstTime = true.obs;
  final RxBool _isLoggedIn = false.obs;

  bool get isFirstTime => _isFirstTime.value;
  bool get isLoggedIn => _isLoggedIn.value;

  @override
  void onInit() {
    _isFirstTime.value = _storage.read('isFirstTime') ?? true;
    _isLoggedIn.value = _storage.read('isLoggedIn') ?? false;
    super.onInit();
  }

  void setFirstTimeDone() {
    _isFirstTime.value = false;
    _storage.write('isFirstTime', false);
  }

  void login(UserModel user) {
    // Aquí iría la lógica real de autenticación
    print('Logging in user: ${user.email}');
    _isLoggedIn.value = true;
    _storage.write('isLoggedIn', true);
  }

void register(UserModel user) {
  print('Registrando: ${user.name}, ${user.email}');
  _isLoggedIn.value = true;
  _storage.write('isLoggedIn', true);
}

void sendResetLink(String email) {
  // Aquí iría tu lógica real de envío de correo (usando Firebase, API, etc.)
  print('Enviando enlace de restablecimiento a $email');
  // También podrías simular con un delay:
  Future.delayed(Duration(seconds: 2), () {
    Get.snackbar('Correo enviado', 'Revisa tu correo electrónico');
  });
}

  void logout() {
    _isLoggedIn.value = false;
    _storage.write('isLoggedIn', false);
  }
}
