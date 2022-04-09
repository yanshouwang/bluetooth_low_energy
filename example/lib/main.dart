import 'package:flutter/material.dart';

import 'views.dart';

void main() {
  final app = MaterialApp(
    theme: ThemeData(
      fontFamily: 'NeverMind',
    ),
    routes: {
      'home': (context) => const HomeView(),
      'gatt': (context) => const GattView(),
    },
    initialRoute: 'home',
  );
  runApp(app);
}
