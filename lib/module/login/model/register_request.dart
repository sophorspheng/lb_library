import 'package:equatable/equatable.dart';

class RegisterRequest extends Equatable {
  const RegisterRequest({
    required this.name,
    required this.email,
    required this.role,
    required this.password,
  });

  final String name;
  final String email;
  final String role;
  final String password;

  @override
  List<Object?> get props => [
        name,
        email,
        role,
        password,
      ];

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'role': role,
        'password': password,
      };
}