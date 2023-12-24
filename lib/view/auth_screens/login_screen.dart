import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../providers/firebase_auth_provider.dart';
import 'otp_verification_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final mobileNoController = TextEditingController();

  @override
  void initState() {
    super.initState();

    mobileNoController.addListener(() {
      setState(() {});
    });

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) {},
    );
  }

  @override
  void dispose() {
    mobileNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.kDefaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: size.height * 0.2),
                      const SizedBox(height: 16),
                      Text(
                        'Login',
                        textAlign: TextAlign.center,
                        style: Theme.of(context)
                            .textTheme
                            .titleLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Enter Your Mobile Number to continue.',
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 42),
                      //--------- text-field ---------
                      TextField(
                        controller: mobileNoController,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      //--------- button ---------
                      ElevatedButton(
                        onPressed: mobileNoController.text.length == 10
                            ? () {
                                Provider.of<FirebaseAuthProvider>(context,
                                        listen: false)
                                    .phoneNumber = mobileNoController.text;
                                Provider.of<FirebaseAuthProvider>(context,
                                        listen: false)
                                    .getFirebaseOtp();

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OTPVerificationScreen()),
                                );
                              }
                            : null,
                        child: const Text('Get OTP'),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
