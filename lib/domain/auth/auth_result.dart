import 'package:flowers_app/domain/auth/user.dart';

class AuthResult {
  final bool _authenticated;
  final String _message;
  final User _user;
  AuthResult({
    required bool authenticated,
    required String message,
    required User user
  }) :
    _authenticated = authenticated, 
    _message = message,
    _user = user;
  bool authenticated() => _authenticated;
  String message() => _message;
  User user() => _user;
} 