import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../generated/assets.dart';
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
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6),
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "( Or )",
                                style: Theme.of(context)
                                    .textTheme
                                    .displayLarge!
                                    .copyWith(fontSize: 14),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Provider.of<FirebaseAuthProvider>(context,
                                      listen: false)
                                  .signInWithGoogle(context);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 10),
                              width: size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.06),
                                border: Border.all(
                                    width: 0.4,
                                    color:
                                        Theme.of(context).colorScheme.primary),
                              ),
                              child: Row(
                                children: [
                                  SvgPicture.asset(
                                    Assets.svgGoogle,
                                    width: 26,
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      "Login via google",
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge!
                                          .copyWith(
                                              fontSize: 14,
                                              color: const Color.fromARGB(
                                                  255, 28, 16, 16),
                                              letterSpacing: 0.3),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.navigate_next,
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
