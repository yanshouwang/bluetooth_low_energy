import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_android_example/view_models.dart';
import 'package:flutter/material.dart';

import 'log_view.dart';

class PeripheralManagerView extends StatelessWidget {
  const PeripheralManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<PeripheralManagerViewModel>(context);
    final state = viewModel.state;
    final advertising = viewModel.advertising;
    final logs = viewModel.logs;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peripheral Manager'),
        actions: [
          TextButton(
            onPressed: state == BluetoothLowEnergyState.poweredOn
                ? () async {
                    if (advertising) {
                      await viewModel.stopAdvertising();
                    } else {
                      await viewModel.startAdvertising();
                    }
                  }
                : null,
            child: Text(advertising ? 'END' : 'BEGIN'),
          ),
        ],
      ),
      body: state == BluetoothLowEnergyState.poweredOn
          ? ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemBuilder: (context, i) {
                final log = logs[i];
                return LogView(
                  log: log,
                );
              },
              itemCount: logs.length,
            )
          : Center(
              child: Text(
                '$state',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
    );
  }
}
