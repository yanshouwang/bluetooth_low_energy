import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/material.dart';

class GattView extends StatefulWidget {
  const GattView({Key? key}) : super(key: key);

  @override
  _GattViewState createState() => _GattViewState();
}

class _GattViewState extends State<GattView> {
  late Central central;
  late MAC address;

  GATT? gatt;

  @override
  void initState() {
    super.initState();
    final arguments =
        ModalRoute.of(context)!.settings.arguments as Map<String, Object>;
    central = arguments['central'] as Central;
    address = arguments['address'] as MAC;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GATT'),
      ),
      body: Container(),
    );
  }
}
