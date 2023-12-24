import 'dart:async';
import 'dart:developer';

import 'package:google_sign_in/google_sign_in.dart';

import '../constant.dart';
import '../view/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class FirebaseAuthProvider with ChangeNotifier {
  FirebaseAuth? auth = FirebaseAuth.instance;

  GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: <String>[
      'email',
    ],
  );

  String phoneNumber = '';
  final phoneOTP = TextEditingController();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String _verificationId = '';
  int? resendToken;

  int resentOTPTimeLeft = 30;
  Timer? localTimer;

  void startTimer() {
    if (localTimer != null && localTimer!.isActive) {
      localTimer!.cancel();
    }

    resentOTPTimeLeft = 30;
    notifyListeners();

    localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resentOTPTimeLeft == 0) {
        localTimer!.cancel();
      } else {
        resentOTPTimeLeft--;
        notifyListeners();
      }
    });
  }

  void cancelTimer() {
    if (localTimer != null) {
      localTimer!.cancel();
    }
  }

  Future<void> resendOtp() async {
    await getFirebaseOtp();
  }

  Future getFirebaseOtp() async {
    startTimer();

    _isLoading = true;
    notifyListeners();
    log('+91$phoneNumber');

    await auth!.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      verificationCompleted: verificationCompleteHandler,
      verificationFailed: verificationFailedHandler,
      codeSent: codeSentHandler,
      codeAutoRetrievalTimeout: autoRetrievalTimeoutHandler,
      forceResendingToken: resendToken,
      timeout: const Duration(seconds: 20),
    );
  }

  verificationCompleteHandler(PhoneAuthCredential credential) async {
    try {
      await signInWithCredential(credential);
    } catch (e) {
      log(e.toString(), name: 'error at verificationCompleteHandler');
    }
  }

  verificationFailedHandler(FirebaseAuthException e) {
    log("print error------------------$e ${e.message} { ${e.code} } ${e.stackTrace}");

    showDialog(
        context: navigatorKey.currentContext!,
        builder: (context) {
          return AlertDialog(
            title: const Text('Technical error!!!'),
            content: const Text(
                'We are facing some technical error. Please try again after sometime.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Okay'))
            ],
          );
        });

    _isLoading = false;
    startTimer();
  }

  codeSentHandler(String verificationId, int? resendToken) {
    if (_isLoading == true) {
      _isLoading = false;
      notifyListeners();
    }

    log(verificationId, name: "VERIFICATION CODE--codeSentHandler--");
    _verificationId = verificationId;
    this.resendToken = resendToken;
    Fluttertoast.showToast(msg: "OTP has been sent to $phoneNumber");
  }

  autoRetrievalTimeoutHandler(String verificationId) {
    log(_verificationId, name: "VERIFICATION CODE--codeAutoRetrievalTimeout--");
    _verificationId = verificationId;
    // if (_isLoading == true) {
    //   _isLoading = false;
    //   notifyListeners();
    // }
  }

  Future<void> signInManually() async {
    log(phoneOTP.text, name: 'OTP');

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: _verificationId, smsCode: phoneOTP.text);
      return await signInWithCredential(credential);
    } catch (e) {
      log('error at signInManually');
    }
  }

  Future<void> signInWithCredential(AuthCredential credential) async {
    log('signInWithCredential CALLED');

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_isLoading == false) {
      _isLoading = true;
      notifyListeners();
    }

    await auth!.signInWithCredential(credential).then((value) async {
      if (value.user != null) {
        if (credential is PhoneAuthCredential) {
          phoneOTP.text = credential.smsCode!;
        }
        log(credential.signInMethod, name: "verificationCompleted");
        String idToken = await value.user!.getIdToken() ?? '';
        log(idToken, name: 'id token');
        log("${value.user}", name: "User Date");

        await prefs.setString(AppConstants.firebaseTokenPrefKey, idToken);
        // ignore: use_build_context_synchronously
        Navigator.pushAndRemoveUntil(
          navigatorKey.currentState!.context,
          MaterialPageRoute(builder: (context) => const DashboardScreen()),
          (route) => false,
        );
      } else {
        String message = "Signing Failed";
        if (credential is PhoneAuthCredential) {
          message = "Invalid OTP";
        }
        Fluttertoast.showToast(msg: message);
      }
    });

    if (_isLoading == true) {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle(context) async {
    if (await googleSignIn.isSignedIn()) {
      googleSignIn.signOut();
    }
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final googleAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await signInWithCredential(googleAuthCredential);
    } catch (e) {
      log(e.toString(), name: "ERROR GOOGLE SIGNIN");
    }
  }

  Future<void> logoutFirebase() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _isLoading = true;
    notifyListeners();

    if (prefs.containsKey(AppConstants.firebaseTokenPrefKey)) {
      await prefs.remove(AppConstants.firebaseTokenPrefKey);
    }
    if (auth != null) {
      await auth!.signOut();
    }

    _isLoading = false;
    notifyListeners();
  }
}
