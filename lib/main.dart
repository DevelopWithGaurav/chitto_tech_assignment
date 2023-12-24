import 'package:flutter/material.dart';

import 'view/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ChittoTechAssignment',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade700),
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}
