import 'package:flutter/material.dart';

import '../auth/domain/auth_service.dart';
import '../auth/domain/auth_state.dart';
import '../common/widgets/loading.dart';

class ProfilePage extends StatelessWidget {
  static const String path = 'profile';
  static const String route = '/profile';

  final AuthService authService;

  const ProfilePage({super.key, required this.authService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [_buildLogoutButton()],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildCardForDisplayName(),
            _buildCardForEmail(),
          ],
        ),
      ),
    );
  }

  Widget _buildCardForEmail() {
    return Card(
      child: ListenableBuilder(
        listenable: authService,
        builder: (context, _) {
          final user = authService.user;
          final isLoading = authService.authState == AuthState.verifyingEmail;

          return ListTile(
            title: Text(user?.email ?? 'No e-mail'),
            subtitle: Text(
              user?.isVerified == true ? 'Verified' : 'Not Verified',
            ),
            trailing: user?.isVerified == true
                ? const Icon(
                    Icons.verified,
                    color: Colors.green,
                  )
                : ElevatedButton(
                    onPressed: isLoading ? null : authService.verifyEmail,
                    child: isLoading ? const Loading() : const Text('Verify'),
                  ),
          );
        },
      ),
    );
  }

  Card _buildCardForDisplayName() {
    return Card(
      child: ListTile(
        title: const Text('Name'),
        subtitle: Text(
          authService.user?.displayName ?? 'No name',
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        final isLoading = authService.authState == AuthState.loggingOut;

        return isLoading
            ? const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Loading(),
              )
            : IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  authService.logout();
                },
              );
      },
    );
  }
}
