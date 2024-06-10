import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../auth/domain/user.dart';
import '../../profile/profile_page.dart';

class GreetingWidget extends StatelessWidget {
  const GreetingWidget({
    super.key,
    required this.user,
  });

  final User? user;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Hello, ${user?.displayName}'),
        IconButton(
          onPressed: () {
            context.go(ProfilePage.route);
          },
          icon: const Icon(Icons.person),
        ),
      ],
    );
  }
}
