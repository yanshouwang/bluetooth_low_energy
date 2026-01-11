import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'router_config.dart';

void main() {
  runZonedGuarded(_body, _onError);
}

void _body() async {
  Logger.root.onRecord.listen(
    (record) => log(
      record.message,
      time: record.time,
      sequenceNumber: record.sequenceNumber,
      level: record.level.value,
      name: record.loggerName,
      zone: record.zone,
      error: record.error,
      stackTrace: record.stackTrace,
    ),
  );
  // Logger.root.level = Level.ALL;
  hierarchicalLoggingEnabled = true;
  Logger('CentralManager').level = Level.WARNING;
  Logger('PeripheralManager').level = Level.WARNING;
  runApp(const MyApp());
}

void _onError(Object error, StackTrace stackTrace) {
  Logger.root.shout('App crached.', error, stackTrace);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: routerConfig,
      theme: ThemeData.light().copyWith(
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      darkTheme: ThemeData.dark().copyWith(
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
    );
  }
}
