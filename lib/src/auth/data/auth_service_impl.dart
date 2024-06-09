import 'package:flutter/material.dart';

import '../domain/auth_service.dart';
import '../domain/auth_state.dart';
import '../domain/user.dart';

class AuthServiceImpl extends ChangeNotifier implements AuthService {
  User? _user;

  @override
  User? get user => _user;

  bool _loggingIn = false;
  bool _loggingOut = false;
  bool _verifyEmailLoading = false;

  @override
  AuthState get authState {
    if (_loggingIn) {
      return AuthState.loggingIn;
    }

    if (_loggingOut) {
      return AuthState.loggingOut;
    }

    if (_verifyEmailLoading) {
      return AuthState.verifyingEmail;
    }

    if (_user == null) {
      return AuthState.unauthenticated;
    }

    if (_user!.isVerified) {
      return AuthState.authenticated;
    }

    return AuthState.emailNotVerified;
  }

  @override
  Future<void> login(String email, String password) async {
    _loggingIn = true;
    notifyListeners();

    if (email.isEmpty || password.isEmpty) {
      _loggingIn = false;
      notifyListeners();
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    _user = User(
      uid: '123456',
      email: email,
      displayName: 'Maurici Ferreira Junior',
      isVerified: false,
    );

    _loggingIn = false;
    notifyListeners();
  }

  @override
  Future<void> logout() async {
    _loggingOut = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _user = null;

    _loggingOut = false;
    notifyListeners();
  }

  @override
  Future<void> verifyEmail() async {
    _verifyEmailLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));
    _user = _user?.copyWith(isVerified: true);

    _verifyEmailLoading = false;
    notifyListeners();
  }
}
