import 'package:chitto_tech_assignment/constant.dart';
import 'package:chitto_tech_assignment/providers/profile_timer_provider.dart';

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
      body: const ProfileBody(),
    );
  }
}

class ProfileBody extends StatefulWidget {
  const ProfileBody({
    super.key,
  });

  @override
  State<ProfileBody> createState() => _ProfileBodyState();
}

class _ProfileBodyState extends State<ProfileBody> {
  bool _showQuestion = false;

  final _answerController = TextEditingController();

  @override
  void dispose() {
    // Provider.of<ProfileTimerProvider>(context, listen: false).cancelTimer();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileTimerProvider>(
        builder: (_, profileTimerProvider, __) {
      return SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 12),
              if (!_showQuestion)
                SizedBox(
                  width: double.maxFinite,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _showQuestion = !_showQuestion;
                      });
                      profileTimerProvider.startTimer();
                    },
                    child: const Text('Win Certificate'),
                  ),
                )
              else
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Time Left:',
                          style: Theme.of(context).textTheme.labelLarge,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          color: Theme.of(context).colorScheme.primary,
                          child: Text(
                            profileTimerProvider.timeLeft.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge!
                                .copyWith(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    Text(
                      'Tell me about yourself?',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _answerController,
                      maxLines: 5,
                      readOnly: profileTimerProvider.timeLeft == 0,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                    ),
                    // const SizedBox(height: 20),
                    // ElevatedButton(
                    //   onPressed:
                    //       profileTimerProvider.timeLeft == 0 ? () {} : null,
                    //   child: const Text('Win Certificate'),
                    // ),
                  ],
                )
            ],
          ),
        ),
      );
    });
  }
}
