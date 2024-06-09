import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/dependency_injection.dart';

void main() {
  setupServiceLocator();
  runApp(const MainApp());
}
