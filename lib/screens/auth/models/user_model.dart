// lib/screens/auth/models/user_model.dart
class UserModel {
  final int? id;            ///  <-- opcional (viene del backend)
  final String nombre;      /// requerido para registro / perfil
  final String email;       /// requerido
  final String? password;   /// <-- opcional (no regresa del backend)

  const UserModel({
    this.id,
    required this.nombre,
    required this.email,
    this.password,
  });

  /// Para registro
  Map<String, dynamic> toJsonRegistro() => {
        'nombre': nombre,
        'email': email,
        'password': password, // aquí sí debe venir
      };

  /// Para login
  Map<String, dynamic> toJsonLogin() => {
        'email': email,
        'password': password, // aquí sí debe venir
      };

  /// Construir desde la respuesta del backend
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] as int?,
        nombre: (json['nombre'] ?? '') as String,
        email: (json['email'] ?? '') as String,
      );
}
