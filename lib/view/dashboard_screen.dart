import 'package:chitto_tech_assignment/providers/bottom_nav_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(builder: (_, bottomNavProvider, __) {
      return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.school),
              label: 'Certificate',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.scoreboard),
              label: 'Score',
            ),
          ],
          currentIndex: bottomNavProvider.activeBottomTab,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: (value) {
            bottomNavProvider.changeTab(value);
          },
        ),
        body: bottomNavProvider.bottomTabs[bottomNavProvider.activeBottomTab],
      );
    });
  }
}
