class UserModel {
  final String name;
  final String email;
  final String password;

  UserModel({
    required this.name,
    required this.email,
    required this.password,
  });

  // Si quieres guardar en JSON / enviar a API
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'password': password,
  };

  // Si quieres construir desde JSON
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    name: json['name'] ?? '',
    email: json['email'] ?? '',
    password: json['password'] ?? '',
  );
}