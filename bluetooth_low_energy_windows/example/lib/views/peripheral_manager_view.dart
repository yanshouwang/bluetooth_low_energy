import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_example/models.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logging/logging.dart';

class PeripheralManagerView extends StatefulWidget {
  const PeripheralManagerView({super.key});

  @override
  State<PeripheralManagerView> createState() => _PeripheralManagerViewState();
}

class _PeripheralManagerViewState extends State<PeripheralManagerView>
    with SingleTickerProviderStateMixin {
  late final PeripheralManager peripheralManager;
  late final ValueNotifier<BluetoothLowEnergyState> state;
  late final ValueNotifier<bool> advertising;
  late final ValueNotifier<List<Log>> logs;
  late final StreamSubscription stateChangedSubscription;
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
    stateChangedSubscription = peripheralManager.stateChanged.listen(
      (eventArgs) {
        state.value = eventArgs.state;
      },
    );
    characteristicReadRequestedSubscription =
        peripheralManager.characteristicReadRequested.listen(
      (eventArgs) async {
        final central = eventArgs.central;
        final request = eventArgs.request;
        final characteristic = request.characteristic;
        final offset = request.offset;
        final elements = List.generate(1000, (i) => i % 256);
        final value = Uint8List.fromList(elements);
        final trimmedValue = value.sublist(offset);
        final log = Log(
          LogType.read,
          Uint8List.fromList([]),
          '${central.uuid} - ${characteristic.uuid}, $offset',
        );
        logs.value = [
          ...logs.value,
          log,
        ];
        await peripheralManager.respondCharacteristicReadRequestWithValue(
          request,
          value: trimmedValue,
        );
      },
    );
    characteristicWriteRequestedSubscription =
        peripheralManager.characteristicWriteRequested.listen(
      (eventArgs) async {
        final central = eventArgs.central;
        final request = eventArgs.request;
        final characteristic = request.characteristic;
        final offset = request.offset;
        final value = request.value;
        final log = Log(
          LogType.write,
          value,
          '${central.uuid} - ${characteristic.uuid}, $offset',
        );
        logs.value = [
          ...logs.value,
          log,
        ];
        await peripheralManager.respondCharacteristicWriteRequest(request);
      },
    );
    characteristicNotifyStateChangedSubscription =
        peripheralManager.characteristicNotifyStateChanged.listen(
      (eventArgs) async {
        final central = eventArgs.central;
        final characteristic = eventArgs.characteristic;
        final state = eventArgs.state;
        final log = Log(
          LogType.notify,
          Uint8List.fromList([]),
          '${central.uuid} - ${characteristic.uuid}, $state',
        );
        logs.value = [
          ...logs.value,
          log,
        ];
        // Write someting to the central when notify started.
        if (state) {
          final elements = List.generate(2000, (i) => i % 256);
          final value = Uint8List.fromList(elements);
          await peripheralManager.notifyCharacteristic(
            characteristic,
            value: value,
          );
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
    final elements = List.generate(1000, (i) => i % 256);
    final value = Uint8List.fromList(elements);
    final service = GATTService(
      uuid: UUID.short(100),
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
            GATTCharacteristicProperty.write,
            GATTCharacteristicProperty.writeWithoutResponse,
          ],
          permissions: [
            GATTCharacteristicPermission.write,
          ],
          descriptors: [],
        ),
        GATTCharacteristic.mutable(
          uuid: UUID.short(202),
          properties: [
            GATTCharacteristicProperty.notify,
          ],
          permissions: [],
          descriptors: [],
        ),
        GATTCharacteristic.mutable(
          uuid: UUID.short(203),
          properties: [
            GATTCharacteristicProperty.indicate,
          ],
          permissions: [],
          descriptors: [],
        ),
        GATTCharacteristic.mutable(
          uuid: UUID.short(204),
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
    final theme = Theme.of(context);
    return ValueListenableBuilder(
      valueListenable: logs,
      builder: (context, logs, child) {
        return ListView.builder(
          itemBuilder: (context, i) {
            final log = logs[i];
            final type = log.type.name.toUpperCase().characters.first;
            final Color typeColor;
            switch (log.type) {
              case LogType.read:
                typeColor = Colors.blue;
                break;
              case LogType.write:
                typeColor = Colors.amber;
                break;
              case LogType.notify:
                typeColor = Colors.red;
                break;
              default:
                typeColor = Colors.black;
            }
            final time = DateFormat.Hms().format(log.time);
            final value = log.value;
            final message = '${log.detail}; ${hex.encode(value)}';
            return Text.rich(
              TextSpan(
                text: '[$type:${value.length}]',
                children: [
                  TextSpan(
                    text: ' $time: ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.green,
                    ),
                  ),
                  TextSpan(
                    text: message,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: typeColor,
                ),
              ),
            );
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
    characteristicReadRequestedSubscription.cancel();
    characteristicWriteRequestedSubscription.cancel();
    characteristicNotifyStateChangedSubscription.cancel();
    state.dispose();
    advertising.dispose();
    logs.dispose();
  }
}
