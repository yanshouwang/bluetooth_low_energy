import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const HomeView({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radar),
            label: 'Central',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Peripheral',
          ),
        ],
        currentIndex: navigationShell.currentIndex,
      ),
    );
  }
}
