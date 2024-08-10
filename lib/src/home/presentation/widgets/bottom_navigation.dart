import 'package:chat/src/utils/icons/assetsicons.dart';
import 'package:flutter/material.dart';

class HomeScreenBottomNavigation extends StatelessWidget {
  const HomeScreenBottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 50,
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      onDestinationSelected: (value) {},
      destinations: <NavigationDestination>[
        NavigationDestination(
          label: 'chats',
          tooltip: 'users',
          icon: Image.asset(
            TIcons.chat,
            height: 25,
          ),
        ),
        const NavigationDestination(
            label: 'users', icon: Icon(Icons.people_alt_outlined))
      ],
    );
  }
}
