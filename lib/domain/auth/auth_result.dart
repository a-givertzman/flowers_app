import 'package:flowers_app/domain/auth/app_user.dart';

class AuthResult {
  final bool _authenticated;
  final String _message;
  final AppUser _user;
  AuthResult({
    required bool authenticated,
    required String message,
    required AppUser user,
  }):
    _authenticated = authenticated, 
    _message = message,
    _user = user;
  bool authenticated() => _authenticated;
  String message() => _message;
  AppUser user() => _user;
}
