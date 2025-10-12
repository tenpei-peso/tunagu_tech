import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../theme/Tunagu_colors.dart';

class RootScreen extends StatelessWidget {
  // StatefulNavigationShellを受け取るように変更
  const RootScreen({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) => Scaffold(
      // bodyにはnavigationShellを渡す
      body: navigationShell,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withValues(alpha: 0.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: TunaguColors.gray300,
              hoverColor: TunaguColors.gray100,
              gap: 8,
              activeColor: TunaguColors.gray900,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: TunaguColors.gray100,
              color: TunaguColors.gray900,
              tabs: const [
                GButton(
                  icon: Icons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.search,
                  text: 'Search',
                ),
                GButton(
                  icon: Icons.message,
                  text: 'Messages',
                ),
                GButton(
                  icon: Icons.settings,
                  text: 'Settings',
                ),
              ],
              selectedIndex: navigationShell.currentIndex,
              onTabChange: (index) {
                _onItemTapped(index, context);
              },
            ),
          ),
        ),
    ),
    );

  void _onItemTapped(int index, BuildContext context) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}