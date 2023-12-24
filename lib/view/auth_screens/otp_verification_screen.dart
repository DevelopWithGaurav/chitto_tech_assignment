import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../constant.dart';
import '../../providers/firebase_auth_provider.dart';

class OTPVerificationScreen extends StatelessWidget {
  const OTPVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(),
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.kDefaultPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: size.height * 0.13),
                            // Image.asset(
                            //   Assets.imagesHorizontalLogo,
                            //   width: 270,
                            // ),
                            const SizedBox(height: 16),
                            Text(
                              'OTP Verification',
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'We have send the code verification to mobile number',
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              '+91 ${Provider.of<FirebaseAuthProvider>(context, listen: false).phoneNumber}',
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 42),
                            PinCodeTextField(
                              autoDisposeControllers: false,
                              appContext: context,
                              length: 6,
                              obscureText: false,
                              animationType: AnimationType.fade,
                              keyboardType: TextInputType.phone,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                selectedColor: Theme.of(context).primaryColor,
                                inactiveColor: Colors.grey,
                                borderWidth: 0.8,
                                inactiveBorderWidth: 0.8,
                                activeBorderWidth: 1,
                                errorBorderWidth: 0.8,
                                disabledBorderWidth: 0.8,
                                selectedBorderWidth: 0.8,
                              ),
                              onChanged: (value) {
                                Provider.of<FirebaseAuthProvider>(context,
                                        listen: false)
                                    .phoneOTP
                                    .text = value;
                              },
                            ),
                            const SizedBox(height: 24),
                            Consumer<FirebaseAuthProvider>(
                                builder: (_, firebaseAuthProvider, __) {
                              return ElevatedButton(
                                onPressed: firebaseAuthProvider
                                            .phoneOTP.text.length ==
                                        6
                                    ? () {
                                        firebaseAuthProvider.signInManually();
                                      }
                                    : null,
                                child: firebaseAuthProvider.isLoading
                                    ? const SizedBox(
                                        height: 25,
                                        width: 25,
                                        child: CircularProgressIndicator())
                                    : const Text('Verify'),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    //--------- resend OTP ---------
                    Column(
                      children: [
                        const Text(
                          'Didn’t you receive any code?',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 3),
                        Consumer<FirebaseAuthProvider>(
                            builder: (_, firebaseAuthProvider, __) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: firebaseAuthProvider.resentOTPTimeLeft !=
                                        0
                                    ? null
                                    : () {
                                        firebaseAuthProvider.getFirebaseOtp();
                                      },
                                child: Material(
                                  child: Text(
                                    'resend otp'.toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .copyWith(
                                          fontSize: 12,
                                          color: firebaseAuthProvider
                                                      .resentOTPTimeLeft ==
                                                  0
                                              ? Colors.blue
                                              : Colors.grey,
                                          decoration: TextDecoration.underline,
                                          decorationColor: firebaseAuthProvider
                                                      .resentOTPTimeLeft ==
                                                  0
                                              ? Colors.blue
                                              : Colors.grey,
                                        ),
                                  ),
                                ),
                              ),
                              if (firebaseAuthProvider.resentOTPTimeLeft != 0)
                                Text(
                                  ' in ${firebaseAuthProvider.resentOTPTimeLeft} seconds',
                                )
                            ],
                          );
                        }),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
