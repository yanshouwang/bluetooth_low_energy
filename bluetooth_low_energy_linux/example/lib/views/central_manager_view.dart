import 'dart:async';

import 'package:bluetooth_low_energy_example/widgets.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logging/logging.dart';

class CentralManagerView extends StatefulWidget {
  const CentralManagerView({super.key});

  @override
  State<CentralManagerView> createState() => _CentralManagerViewState();
}

class _CentralManagerViewState extends State<CentralManagerView> {
  late final CentralManager centralManager;
  late final ValueNotifier<BluetoothLowEnergyState> state;
  late final ValueNotifier<bool> discovering;
  late final ValueNotifier<List<DiscoveredEventArgs>> eventArgses;
  late final StreamSubscription stateChangedSubscription;
  late final StreamSubscription discoveredSubscription;

  @override
  void initState() {
    super.initState();
    centralManager = CentralManager();
    centralManager.logLevel = Level.INFO;
    state = ValueNotifier(centralManager.state);
    discovering = ValueNotifier(false);
    eventArgses = ValueNotifier([]);
    stateChangedSubscription = centralManager.stateChanged.listen(
      (eventArgs) {
        state.value = eventArgs.state;
      },
    );
    discoveredSubscription = centralManager.discovered.listen(
      (eventArgs) {
        final eventArgses = this.eventArgses.value;
        final index = eventArgses.indexWhere(
          (item) => item.peripheral == eventArgs.peripheral,
        );
        if (index < 0) {
          this.eventArgses.value = [...eventArgses, eventArgs];
        } else {
          eventArgses[index] = eventArgs;
          this.eventArgses.value = [...eventArgses];
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Central Manager'),
      actions: [
        ValueListenableBuilder(
          valueListenable: state,
          builder: (context, state, child) {
            return ValueListenableBuilder(
              valueListenable: discovering,
              builder: (context, discovering, child) {
                return TextButton(
                  onPressed: state == BluetoothLowEnergyState.poweredOn
                      ? () async {
                          if (discovering) {
                            await stopDiscovery();
                          } else {
                            await startDiscovery();
                          }
                        }
                      : null,
                  child: Text(
                    discovering ? 'END' : 'BEGIN',
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> startDiscovery() async {
    eventArgses.value = [];
    // final serviceUUIDs = [
    //   UUID.short(0x180f),
    //   // UUID.short(0xfd92),
    // ];
    // await centralManager.startDiscovery(
    //   serviceUUIDs: serviceUUIDs,
    // );
    await centralManager.startDiscovery();
    discovering.value = true;
  }

  Future<void> stopDiscovery() async {
    await centralManager.stopDiscovery();
    discovering.value = false;
  }

  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: eventArgses,
      builder: (context, eventArgses, child) {
        return ListView.separated(
          itemBuilder: (context, i) {
            final theme = Theme.of(context);
            final eventArgs = eventArgses[i];
            final uuid = eventArgs.peripheral.uuid;
            final rssi = eventArgs.rssi;
            final advertisement = eventArgs.advertisement;
            final name = advertisement.name;
            return ListTile(
              onTap: () {
                onTapEventArgs(eventArgs);
              },
              onLongPress: () {
                onLongPressEventArgs(eventArgs);
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
                  RssiIndicator(rssi),
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
          itemCount: eventArgses.length,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    stateChangedSubscription.cancel();
    discoveredSubscription.cancel();
    state.dispose();
    discovering.dispose();
    eventArgses.dispose();
  }

  void onTapEventArgs(DiscoveredEventArgs eventArgs) async {
    final discovering = this.discovering.value;
    if (discovering) {
      await stopDiscovery();
    }
    if (!mounted) {
      return;
    }
    await context.push(
      '/central-manager/peripheral',
      extra: eventArgs,
    );
    if (discovering) {
      await startDiscovery();
    }
  }

  void onLongPressEventArgs(DiscoveredEventArgs eventArgs) async {
    final advertisement = eventArgs.advertisement;
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          clipBehavior: Clip.antiAlias,
          builder: (context) {
            final manufacturerSpecificData =
                advertisement.manufacturerSpecificData;
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
