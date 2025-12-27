part of '../../data.dart';

class LoginParams {
  LoginParams({
    required this.username,
    required this.password,
  });

  final String username;
  final String password;

  String toJson() => json.encode(toMap()).englishNumber();

  Map<String, dynamic> toMap() => <String, dynamic>{
    "phone_number": username,
    "password": password,
  };
}
