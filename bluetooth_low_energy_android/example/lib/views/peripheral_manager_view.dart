import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_android_example/view_models.dart';
import 'package:clover/clover.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import 'log_view.dart';

class PeripheralManagerView extends StatelessWidget {
  const PeripheralManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<PeripheralManagerViewModel>(context);
    final state = viewModel.state;
    final advertising = viewModel.advertising;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peripheral Manager'),
        actions: [
          TextButton(
            onPressed:
                state == BluetoothLowEnergyState.on
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
      body: buildBody(context),
      floatingActionButton:
          state == BluetoothLowEnergyState.on
              ? FloatingActionButton(
                onPressed: () => viewModel.clearLogs(),
                child: const Icon(Symbols.delete),
              )
              : null,
    );
  }

  Widget buildBody(BuildContext context) {
    final viewModel = ViewModel.of<PeripheralManagerViewModel>(context);
    final state = viewModel.state;
    if (state == BluetoothLowEnergyState.unauthorized) {
      return Center(
        child: TextButton(
          onPressed: () => viewModel.showAppSettings(),
          child: const Text('Go to settings'),
        ),
      );
    } else if (state == BluetoothLowEnergyState.on) {
      final logs = viewModel.logs;
      return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemBuilder: (context, i) {
          final log = logs[i];
          return LogView(log: log);
        },
        itemCount: logs.length,
      );
    } else {
      return Center(
        child: Text('$state', style: Theme.of(context).textTheme.titleMedium),
      );
    }
  }
}
