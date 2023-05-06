import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy_example/view_models.dart';
import 'package:flutter/material.dart';

import 'peripheral_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final HomeViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = HomeViewModel();
    viewModel.startScan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home View'),
      ),
      body: ValueListenableBuilder<CentralManagerState>(
        valueListenable: viewModel.state,
        builder: (context, state, child) {
          switch (state) {
            case CentralManagerState.poweredOn:
              return buildPeripheralsView(context);
            default:
              return Center(
                child: Text('Adapter state: $state'),
              );
          }
        },
      ),
    );
  }

  Widget buildPeripheralsView(BuildContext context) {
    return ValueListenableBuilder<List<Peripheral>>(
      valueListenable: viewModel.peripherals,
      builder: (context, peripherals, child) {
        return ListView.separated(
          itemBuilder: (context, i) {
            final peripheral = peripherals[i];
            return ListTile(
              onTap: () async {
                viewModel.stopScan();
                await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        PeripheralView(peripheral: peripheral),
                  ),
                );
                viewModel.startScan();
              },
              tileColor: Theme.of(context).colorScheme.surface,
              title: Text(peripheral.name),
              subtitle: Text(peripheral.id),
              trailing: Text('${peripheral.rssi}'),
            );
          },
          separatorBuilder: (context, i) {
            return const Divider();
          },
          itemCount: peripherals.length,
        );
      },
    );
  }
}
