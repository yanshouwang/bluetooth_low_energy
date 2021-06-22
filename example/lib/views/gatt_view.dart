import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/material.dart';

class GattView extends StatefulWidget {
  const GattView({Key? key}) : super(key: key);

  @override
  _GattViewState createState() => _GattViewState();
}

class _GattViewState extends State<GattView> {
  late MAC address;
  ValueNotifier<String> state;

  _GattViewState() : state = ValueNotifier('Disconnected');

  GATT? gatt;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    address = ModalRoute.of(context)!.settings.arguments as MAC;
    connect();
    return Scaffold(
      appBar: AppBar(
        title: Text('GATT'),
      ),
      body: ValueListenableBuilder(
        valueListenable: state,
        builder: (context, String state, child) {
          return Center(
            child: Text(state),
          );
        },
      ),
    );
  }

  void connect() async {
    gatt = await central.connect(address);
    state.value = 'Connected with MTU: ${gatt!.mtu}';
    await gatt!.connectionLost.first;
    state.value = 'Connection Lost';
  }
}
