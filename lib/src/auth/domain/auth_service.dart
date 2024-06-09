import 'package:flutter/material.dart';

import 'auth_state.dart';
import 'user.dart';

abstract interface class AuthService extends ChangeNotifier {
  User? get user;
  AuthState get authState;
  Future<void> login(String email, String password);
  Future<void> logout();
  Future<void> verifyEmail();
}
