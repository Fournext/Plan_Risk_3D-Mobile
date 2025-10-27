// lib/api/auth_service.dart
import 'package:get/get.dart';

class AuthService extends GetConnect {
  AuthService(String baseUrl) {
    httpClient.baseUrl = baseUrl; // <-- ¡TIENE que ser un String!
    httpClient.timeout = const Duration(seconds: 15);
    httpClient.defaultContentType = 'application/json';
  }

  Future<Response> register(Map<String, dynamic> body) =>
      post('api/users/auth/registro/', body);

  Future<Response> login(Map<String, dynamic> body) =>
      post('api/users/auth/login/', body);

  Future<Response> logout(String token) => post(
    'api/users/auth/logout/',
    {},
    headers: {'Authorization': 'Bearer $token'},
  );

  Future<Response> updateProfile(
    String token,
    Map<String, dynamic> body,
  ) async {
    return patch(
      '$baseUrl/usuarios/me/',
      body,
      headers: {'Authorization': 'Bearer $token'},
    );
  }
}
