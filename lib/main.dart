import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/bottom_nav_provider.dart';
import 'providers/firebase_auth_provider.dart';
import 'providers/profile_timer_provider.dart';
import 'view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => BottomNavProvider()),
        ChangeNotifierProvider(create: (ctx) => FirebaseAuthProvider()),
        ChangeNotifierProvider(create: (ctx) => ProfileTimerProvider()),
      ],
      child: MaterialApp(
        title: 'ChittooTechAssignment',
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        theme: ThemeData(
          colorScheme:
              ColorScheme.fromSeed(seedColor: Colors.blueGrey.shade700),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
