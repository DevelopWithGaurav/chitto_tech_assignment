import 'package:flutter/material.dart';

import '../view/ceritificate_screen.dart';
import '../view/chat_screen.dart';
import '../view/profile_screen.dart';
import '../view/score_screen.dart';

class BottomNavProvider with ChangeNotifier {
  List<Widget> bottomTabs = [
    const CertificateScreen(),
    const ProfileScreen(),
    const ChatScreen(),
    const ScoreScreen(),
  ];

  int activeBottomTab = 1;

  void changeTab(int tabIndex) {
    activeBottomTab = tabIndex;
    notifyListeners();
  }
}
