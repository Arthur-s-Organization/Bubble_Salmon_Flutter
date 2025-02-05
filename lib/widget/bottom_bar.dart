import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final int currentIndex;
  final BuildContext context;

  void onTabSelected(int index) {
    if (index == 0) {
      Navigator.pushNamed(context, '/contact');
    } else if (index == 1) {
      Navigator.pushNamed(context, '/home');
    } else if (index == 2) {
      Navigator.pushNamed(context, '/account');
    }
  }

  const BottomBar(
      {super.key, required this.currentIndex, required this.context});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      currentIndex: currentIndex,
      onTap: (index) => onTabSelected(index),
      iconSize: 32,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.contacts_outlined),
          label: 'Contacts',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_outlined),
          label: 'Bulles',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle_outlined),
          label: 'Compte',
        ),
      ],
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor:
          Theme.of(context).colorScheme.primary.withOpacity(0.5),
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }
}
