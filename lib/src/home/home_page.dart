import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../profile/profile_page.dart';

class HomePage extends StatelessWidget {
  static const String path = '/';

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        actions: [
          IconButton(
            onPressed: () {
              context.go(ProfilePage.route);
            },
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: const Center(
        child: Text('Home Page'),
      ),
    );
  }
}
