import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy_example/view_models.dart';
import 'package:flutter/material.dart' hide ConnectionState;

class PeripheralView extends StatefulWidget {
  final Peripheral peripheral;

  const PeripheralView({
    super.key,
    required this.peripheral,
  });

  @override
  State<PeripheralView> createState() => _PeripheralViewState();
}

class _PeripheralViewState extends State<PeripheralView> {
  late final PeripheralViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = PeripheralViewModel(widget.peripheral);
    viewModel.connect();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.sync(() {
        viewModel.disconnect();
        return true;
      }),
      child: Scaffold(
        appBar: AppBar(
          title: Text(viewModel.name),
        ),
        body: Center(
          child: StreamBuilder<PeripheralState>(
            stream: viewModel.stateChanged,
            builder: (context, snapshot) {
              final state = snapshot.hasData
                  ? snapshot.requireData
                  : PeripheralState.disconnected;
              switch (state) {
                case PeripheralState.connected:
                  return buildConnectedView(context);
                case PeripheralState.connecting:
                  return buildConnectingView(context);
                default:
                  return buildDisconnectedView(context);
              }
            },
          ),
        ),
      ),
    );
  }

  Widget buildDisconnectedView(BuildContext context) {
    return const Text('DISCONNECTED');
  }

  Widget buildConnectingView(BuildContext context) {
    return const CircularProgressIndicator();
  }

  Widget buildConnectedView(BuildContext context) {
    return const Text('CONNECTED');
  }
}
