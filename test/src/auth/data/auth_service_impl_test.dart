import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_app/src/auth/data/auth_service_impl.dart';
import 'package:top_up_app/src/auth/domain/auth_state.dart';

void main() {
  group('AuthServiceImpl', () {
    group('Login', () {
      test('Login with valid email and password', () async {
        // Arrange
        const email = 'not_empty@email.com';
        const password = '123456';
        final authService = AuthServiceImpl();

        // Act
        await authService.login(email, password);

        // Assert
        expect(authService.user, isNotNull);
        expect(authService.authState, AuthState.emailNotVerified);
      });

      test('Login with invalid email and password', () async {
        // Arrange
        const email = '';
        const password = '';
        final authService = AuthServiceImpl();

        // Act
        await authService.login(email, password);

        // Assert
        expect(authService.user, isNull);
        expect(authService.authState, AuthState.unauthenticated);
      });
    });

    group('Logout', () {
      test('Logout logged in user', () async {
        // Arrange
        const email = 'not_empty@email.com';
        const password = '123456';
        final authService = AuthServiceImpl();

        await authService.login(email, password);
        expect(authService.user, isNotNull);
        expect(authService.authState, AuthState.emailNotVerified);

        // Act
        await authService.logout();

        // Assert
        expect(authService.user, isNull);
        expect(authService.authState, AuthState.unauthenticated);
      });

      test('Logout not logged in user', () async {
        // Arrange
        final authService = AuthServiceImpl();

        // Act
        await authService.logout();

        // Assert
        expect(authService.user, isNull);
        expect(authService.authState, AuthState.unauthenticated);
      });
    });

    group('Verify email', () {
      test('Verify email of a logged in user', () async {
        // Arrange
        const email = 'not_empty@email.com';
        const password = '123456';
        final authService = AuthServiceImpl();

        await authService.login(email, password);
        expect(authService.user, isNotNull);
        expect(authService.authState, AuthState.emailNotVerified);

        // Act
        await authService.verifyEmail();

        // Assert
        expect(authService.user, isNotNull);
        expect(authService.user?.isVerified, isTrue);
        expect(authService.authState, AuthState.authenticated);
      });

      test('Verify email of a not logged in user', () async {
        // Arrange
        final authService = AuthServiceImpl();

        // Act
        await authService.verifyEmail();

        // Assert
        expect(authService.user, isNull);
        expect(authService.user?.isVerified, isNull);
        expect(authService.authState, AuthState.unauthenticated);
      });
    });
  });
}
