import 'package:flutter/material.dart';

class BottomNavProvider with ChangeNotifier {
  int activeBottomTab = 1;

  void changeTab(int tabIndex) {
    activeBottomTab = tabIndex;
    notifyListeners();
  }
}
