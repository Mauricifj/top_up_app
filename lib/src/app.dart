import 'package:flutter/material.dart';

import 'router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Top up app',
      routerConfig: router,
      theme: ThemeData(primarySwatch: Colors.blueGrey, useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: ThemeMode.light,
    );
  }
}
