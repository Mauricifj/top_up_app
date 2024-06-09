import 'package:flutter/material.dart';

import '../../common/widgets/loading.dart';
import '../domain/auth_service.dart';
import '../domain/auth_state.dart';

class LoginPage extends StatefulWidget {
  static const String path = '/login';

  final AuthService authService;

  const LoginPage({super.key, required this.authService});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const FlutterLogo(size: 64),
              const SizedBox(height: 16),
              const Text(
                'Login',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: hidePassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                        hidePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildLoginButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoginButton() {
    return ListenableBuilder(
      listenable: widget.authService,
      builder: (context, _) {
        final isLoading = widget.authService.authState == AuthState.loggingIn;

        return ElevatedButton(
          onPressed: isLoading ? null : login,
          child: isLoading ? const Loading() : const Text('Login'),
        );
      },
    );
  }

  void login() async {
    await widget.authService.login(
      emailController.text,
      passwordController.text,
    );

    if (widget.authService.authState == AuthState.unauthenticated) {
      if (mounted) {
        final scaffoldMessenger = ScaffoldMessenger.of(context);
        scaffoldMessenger.clearSnackBars();
        scaffoldMessenger.showSnackBar(
          const SnackBar(
            content: Text('Please, verify your email and password'),
          ),
        );
      }
    }
  }
}
