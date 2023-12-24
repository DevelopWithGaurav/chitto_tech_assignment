import 'package:chitto_tech_assignment/providers/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => BottomNavProvider()),
      ],
      child: MaterialApp(
        title: 'ChittoTechAssignment',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade700),
          useMaterial3: true,
        ),
        home: const DashboardScreen(),
      ),
    );
  }
}
