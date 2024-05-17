import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_windows_example/models.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:logging/logging.dart';

class PeripheralManagerView extends StatefulWidget {
  const PeripheralManagerView({super.key});

  @override
  State<PeripheralManagerView> createState() => _PeripheralManagerViewState();
}

class _PeripheralManagerViewState extends State<PeripheralManagerView>
    with TypeLogger {
  late final PeripheralManager peripheralManager;
  late final ValueNotifier<BluetoothLowEnergyState> state;
  late final ValueNotifier<bool> advertising;
  late final ValueNotifier<List<Log>> logs;
  late final StreamSubscription stateChangedSubscription;
  late final StreamSubscription connectionStateChangedSubscription;
  late final StreamSubscription mtuChangedSubscription;
  late final StreamSubscription characteristicReadRequestedSubscription;
  late final StreamSubscription characteristicWriteRequestedSubscription;
  late final StreamSubscription characteristicNotifyStateChangedSubscription;

  @override
  void initState() {
    super.initState();
    peripheralManager = PeripheralManager();
    peripheralManager.logLevel = Level.INFO;
    state = ValueNotifier(peripheralManager.state);
    advertising = ValueNotifier(false);
    logs = ValueNotifier([]);
    final elements = List.generate(100, (i) => i % 256);
    final value = Uint8List.fromList(elements);
    stateChangedSubscription =
        peripheralManager.stateChanged.listen((eventArgs) {
      state.value = eventArgs.state;
    });
    connectionStateChangedSubscription =
        peripheralManager.connectionStateChanged.listen((eventArgs) {
      final central = eventArgs.central;
      final state = eventArgs.state;
      logger.info('connectionStateChanged: ${central.uuid} - $state');
    });
    mtuChangedSubscription = peripheralManager.mtuChanged.listen((eventArgs) {
      final central = eventArgs.central;
      final mtu = eventArgs.mtu;
      logger.info('mtuChanged: ${central.uuid} - $mtu');
    });
    characteristicReadRequestedSubscription =
        peripheralManager.characteristicReadRequested.listen((eventArgs) async {
      final central = eventArgs.central;
      final characteristic = eventArgs.characteristic;
      final request = eventArgs.request;
      final offset = request.offset;
      final log = Log(
        'characteristicReadRequested\n${central.uuid} - ${characteristic.uuid}, $offset',
      );
      logs.value = [
        ...logs.value,
        log,
      ];
      final trimmedValue = value.sublist(offset);
      await peripheralManager.respondCharacteristicReadRequestWithValue(
        central,
        characteristic,
        request: request,
        value: trimmedValue,
      );
    });
    characteristicWriteRequestedSubscription = peripheralManager
        .characteristicWriteRequested
        .listen((eventArgs) async {
      final central = eventArgs.central;
      final characteristic = eventArgs.characteristic;
      final request = eventArgs.request;
      final offset = request.offset;
      final value = request.value;
      final log = Log(
        'characteristicWriteRequested\n${central.uuid} - ${characteristic.uuid}, $offset, $value',
      );
      logs.value = [
        ...logs.value,
        log,
      ];
      await peripheralManager.respondCharacteristicWriteRequest(
        central,
        characteristic,
        request: request,
      );
    });
    characteristicNotifyStateChangedSubscription = peripheralManager
        .characteristicNotifyStateChanged
        .listen((eventArgs) async {
      final central = eventArgs.central;
      final characteristic = eventArgs.characteristic;
      final state = eventArgs.state;
      final log = Log(
        'characteristicNotifyStateChanged\n${central.uuid} - ${characteristic.uuid}, $state',
      );
      logs.value = [
        ...logs.value,
        log,
      ];
      // Write someting to the central when notify started.
      if (state) {
        final elements = List.generate(1000, (i) => i % 256);
        final value = Uint8List.fromList(elements);
        await peripheralManager.notifyCharacteristic(
          central,
          characteristic,
          value: value,
        );
      }
    });
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
      title: const Text('Peripheral Manager'),
      actions: [
        ValueListenableBuilder(
          valueListenable: state,
          builder: (context, state, child) {
            return ValueListenableBuilder(
              valueListenable: advertising,
              builder: (context, advertising, child) {
                return TextButton(
                  onPressed: state == BluetoothLowEnergyState.poweredOn
                      ? () async {
                          if (advertising) {
                            await stopAdvertising();
                          } else {
                            await startAdvertising();
                          }
                        }
                      : null,
                  child: Text(
                    advertising ? 'END' : 'BEGIN',
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Future<void> startAdvertising() async {
    await peripheralManager.removeAllServices();
    final elements = List.generate(100, (i) => i % 256);
    final value = Uint8List.fromList(elements);
    final service = GATTService(
      uuid: UUID.short(100),
      isPrimary: true,
      includedServices: [],
      characteristics: [
        GATTCharacteristic.immutable(
          uuid: UUID.short(200),
          value: value,
          descriptors: [],
        ),
        GATTCharacteristic.mutable(
          uuid: UUID.short(201),
          properties: [
            GATTCharacteristicProperty.read,
            GATTCharacteristicProperty.write,
            GATTCharacteristicProperty.writeWithoutResponse,
            GATTCharacteristicProperty.notify,
            GATTCharacteristicProperty.indicate,
          ],
          permissions: [
            GATTCharacteristicPermission.read,
            GATTCharacteristicPermission.write,
          ],
          descriptors: [],
        ),
      ],
    );
    await peripheralManager.addService(service);
    final advertisement = Advertisement(
      name: 'le12138',
      manufacturerSpecificData: ManufacturerSpecificData(
        id: 0x2e19,
        data: Uint8List.fromList([0x01, 0x02, 0x03]),
      ),
    );
    await peripheralManager.startAdvertising(advertisement);
    advertising.value = true;
  }

  Future<void> stopAdvertising() async {
    await peripheralManager.stopAdvertising();
    advertising.value = false;
  }

  Widget buildBody(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: logs,
      builder: (context, logs, child) {
        return ListView.builder(
          itemBuilder: (context, i) {
            final log = logs[i];
            return Text('$log');
          },
          itemCount: logs.length,
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    stateChangedSubscription.cancel();
    connectionStateChangedSubscription.cancel();
    mtuChangedSubscription.cancel();
    characteristicReadRequestedSubscription.cancel();
    characteristicWriteRequestedSubscription.cancel();
    characteristicNotifyStateChangedSubscription.cancel();
    state.dispose();
    advertising.dispose();
    logs.dispose();
  }
}
