import 'package:flutter/material.dart';

import 'views.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        platform: TargetPlatform.iOS,
        fontFamily: 'IBM Plex Mono',
      ),
      home: HomeView(),
      routes: {
        'gatt': (context) => GattView(),
      },
    );
  }
}
