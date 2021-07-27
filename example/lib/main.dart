import 'package:flutter/material.dart';

import 'views.dart';

void main() {
  final app = MaterialApp(
    theme: ThemeData(
      fontFamily: 'IBM Plex Mono',
    ),
    routes: {
      'home': (context) => HomeView(),
      'gatt': (context) => GattView(),
    },
    initialRoute: 'home',
  );
  runApp(app);
}
