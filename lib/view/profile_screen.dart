import 'auth_screens/login_screen.dart';

import '../providers/firebase_auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          Consumer<FirebaseAuthProvider>(
              builder: (_, firebaseAuthProvider, __) {
            return IconButton(
              onPressed: firebaseAuthProvider.isLoading
                  ? null
                  : () {
                      firebaseAuthProvider.logoutFirebase().then((value) {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false);
                      });
                    },
              icon: firebaseAuthProvider.isLoading
                  ? const SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(),
                    )
                  : const Icon(Icons.logout),
            );
          }),
        ],
      ),
    );
  }
}
