import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_windows_example/view_models.dart';
import 'package:bluetooth_low_energy_windows_example/widgets.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CentralManagerView extends StatelessWidget {
  const CentralManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<CentralManagerViewModel>(context);
    final state = viewModel.state;
    final discovering = viewModel.discovering;
    final discoveries = viewModel.discoveries;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Central Manager'),
        actions: [
          TextButton(
            onPressed: state == BluetoothLowEnergyState.poweredOn
                ? () async {
                    if (discovering) {
                      await viewModel.stopDiscovery();
                    } else {
                      await viewModel.startDiscovery();
                    }
                  }
                : null,
            child: Text(discovering ? 'END' : 'BEGIN'),
          ),
        ],
      ),
      body: state == BluetoothLowEnergyState.poweredOn
          ? ListView.separated(
              itemBuilder: (context, index) {
                final theme = Theme.of(context);
                final discovery = discoveries[index];
                final uuid = discovery.peripheral.uuid;
                final name = discovery.advertisement.name;
                final rssi = discovery.rssi;
                return ListTile(
                  onTap: () {
                    onTapDissovery(context, discovery);
                  },
                  onLongPress: () {
                    onLongPressDiscovery(context, discovery);
                  },
                  title: Text(name ?? ''),
                  subtitle: Text(
                    '$uuid',
                    style: theme.textTheme.bodySmall,
                    softWrap: false,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RSSIIndicator(rssi),
                      Text('$rssi'),
                    ],
                  ),
                );
              },
              separatorBuilder: (context, i) {
                return const Divider(
                  height: 0.0,
                );
              },
              itemCount: discoveries.length,
            )
          : Center(
              child: Text(
                '$state',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
    );
  }

  void onTapDissovery(
      BuildContext context, DiscoveredEventArgs discovery) async {
    final viewModel = ViewModel.of<CentralManagerViewModel>(context);
    if (viewModel.discovering) {
      await viewModel.stopDiscovery();
      if (!context.mounted) {
        return;
      }
    }
    final uuid = discovery.peripheral.uuid;
    context.go('/devices/$uuid');
  }

  void onLongPressDiscovery(
      BuildContext context, DiscoveredEventArgs discovery) async {
    final manufacturerSpecificData =
        discovery.advertisement.manufacturerSpecificData;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          clipBehavior: Clip.antiAlias,
          builder: (context) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 40.0,
              ),
              itemBuilder: (context, i) {
                const idWidth = 80.0;
                if (i == 0) {
                  return const Row(
                    children: [
                      SizedBox(
                        width: idWidth,
                        child: Text('ID'),
                      ),
                      Expanded(
                        child: Text('DATA'),
                      ),
                    ],
                  );
                } else {
                  final id =
                      '0x${manufacturerSpecificData!.id.toRadixString(16).padLeft(4, '0')}';
                  final value = hex.encode(manufacturerSpecificData.data);
                  return Row(
                    children: [
                      SizedBox(
                        width: idWidth,
                        child: Text(id),
                      ),
                      Expanded(
                        child: Text(value),
                      ),
                    ],
                  );
                }
              },
              separatorBuilder: (context, i) {
                return const Divider();
              },
              itemCount: manufacturerSpecificData == null ? 1 : 2,
            );
          },
        );
      },
    );
  }
}
