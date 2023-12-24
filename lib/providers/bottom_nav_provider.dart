import 'package:chitto_tech_assignment/view/ceritificate_screen.dart';
import 'package:chitto_tech_assignment/view/chat_screen.dart';
import 'package:chitto_tech_assignment/view/profile_screen.dart';
import 'package:chitto_tech_assignment/view/score_screen.dart';
import 'package:flutter/material.dart';

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
