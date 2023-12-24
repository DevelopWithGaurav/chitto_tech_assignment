import 'dart:async';

import 'package:flutter/material.dart';

class ProfileTimerProvider with ChangeNotifier {
  int timeLeft = 30;
  Timer? localTimer;

  void startTimer() {
    if (localTimer != null && localTimer!.isActive) {
      localTimer!.cancel();
    }

    timeLeft = 30;
    notifyListeners();

    localTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft == 0) {
        localTimer!.cancel();
      } else {
        timeLeft--;
        notifyListeners();
      }
    });
  }

  void cancelTimer() {
    timeLeft = 30;
    if (localTimer != null) {
      localTimer!.cancel();
    }
  }
}
