import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_low_energy_example/models.dart';
import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeripheralView extends StatefulWidget {
  final DiscoveredEventArgs eventArgs;

  const PeripheralView({
    super.key,
    required this.eventArgs,
  });

  @override
  State<PeripheralView> createState() => _PeripheralViewState();
}

class _PeripheralViewState extends State<PeripheralView> {
  late final CentralManager centralManager;
  late final ValueNotifier<bool> connectionState;
  late final DiscoveredEventArgs eventArgs;
  late final ValueNotifier<List<GattService>> services;
  late final ValueNotifier<List<GattCharacteristic>> characteristics;
  late final ValueNotifier<GattService?> service;
  late final ValueNotifier<GattCharacteristic?> characteristic;
  late final ValueNotifier<GattCharacteristicWriteType> writeType;
  late final ValueNotifier<List<Log>> logs;
  late final TextEditingController writeController;
  late final StreamSubscription connectionStateChangedSubscription;
  late final StreamSubscription characteristicNotifiedSubscription;

  @override
  void initState() {
    super.initState();
    eventArgs = widget.eventArgs;
    centralManager = CentralManager();
    connectionState = ValueNotifier(false);
    services = ValueNotifier([]);
    characteristics = ValueNotifier([]);
    service = ValueNotifier(null);
    characteristic = ValueNotifier(null);
    writeType = ValueNotifier(GattCharacteristicWriteType.withResponse);
    logs = ValueNotifier([]);
    writeController = TextEditingController();
    connectionStateChangedSubscription =
        centralManager.connectionStateChanged.listen(
      (eventArgs) {
        if (eventArgs.peripheral != this.eventArgs.peripheral) {
          return;
        }
        final connectionState = eventArgs.connectionState;
        this.connectionState.value = connectionState;
        if (!connectionState) {
          services.value = [];
          characteristics.value = [];
          service.value = null;
          characteristic.value = null;
          logs.value = [];
        }
      },
    );
    characteristicNotifiedSubscription =
        centralManager.characteristicNotified.listen(
      (eventArgs) {
        // final characteristic = this.characteristic.value;
        // if (eventArgs.characteristic != characteristic) {
        //   return;
        // }
        const type = LogType.notify;
        final log = Log(type, eventArgs.value);
        logs.value = [
          ...logs.value,
          log,
        ];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) async {
        if (connectionState.value) {
          final peripheral = eventArgs.peripheral;
          await centralManager.disconnect(peripheral);
        }
      },
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildBody(context),
      ),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    final title = eventArgs.advertisement.name ?? '';
    return AppBar(
      title: Text(title),
      actions: [
        ValueListenableBuilder(
          valueListenable: connectionState,
          builder: (context, state, child) {
            return TextButton(
              onPressed: () async {
                final peripheral = eventArgs.peripheral;
                if (state) {
                  await centralManager.disconnect(peripheral);
                } else {
                  await centralManager.connect(peripheral);
                  services.value =
                      await centralManager.discoverGATT(peripheral);
                }
              },
              child: Text(state ? 'DISCONNECT' : 'CONNECT'),
            );
          },
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder(
            valueListenable: services,
            builder: (context, services, child) {
              final items = services.map((service) {
                return DropdownMenuItem(
                  value: service,
                  child: Text(
                    '${service.uuid}',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList();
              return ValueListenableBuilder(
                valueListenable: service,
                builder: (context, service, child) {
                  return DropdownButton(
                    isExpanded: true,
                    items: items,
                    hint: const Text('CHOOSE A SERVICE'),
                    value: service,
                    onChanged: (service) async {
                      this.service.value = service;
                      characteristic.value = null;
                      if (service == null) {
                        return;
                      }
                      characteristics.value = service.characteristics;
                    },
                  );
                },
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: characteristics,
            builder: (context, characteristics, child) {
              final items = characteristics.map((characteristic) {
                return DropdownMenuItem(
                  value: characteristic,
                  child: Text(
                    '${characteristic.uuid}',
                    style: theme.textTheme.bodyMedium,
                  ),
                );
              }).toList();
              return ValueListenableBuilder(
                valueListenable: characteristic,
                builder: (context, characteristic, child) {
                  return DropdownButton(
                    isExpanded: true,
                    items: items,
                    hint: const Text('CHOOSE A CHARACTERISTIC'),
                    value: characteristic,
                    onChanged: (characteristic) {
                      if (characteristic == null) {
                        return;
                      }
                      this.characteristic.value = characteristic;
                      final writeType = this.writeType.value;
                      final canWrite = characteristic.properties.contains(
                        GattCharacteristicProperty.write,
                      );
                      final canWriteWithoutResponse =
                          characteristic.properties.contains(
                        GattCharacteristicProperty.writeWithoutResponse,
                      );
                      if (writeType ==
                              GattCharacteristicWriteType.withResponse &&
                          !canWrite &&
                          canWriteWithoutResponse) {
                        this.writeType.value =
                            GattCharacteristicWriteType.withoutResponse;
                      }
                      if (writeType ==
                              GattCharacteristicWriteType.withoutResponse &&
                          !canWriteWithoutResponse &&
                          canWrite) {
                        this.writeType.value =
                            GattCharacteristicWriteType.withResponse;
                      }
                    },
                  );
                },
              );
            },
          ),
          Expanded(
            child: ValueListenableBuilder(
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
                    final message = hex.encode(value);
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
            ),
          ),
          ValueListenableBuilder(
            valueListenable: characteristic,
            builder: (context, characteristic, chld) {
              final bool canNotify, canRead, canWrite, canWriteWithoutResponse;
              if (characteristic == null) {
                canNotify =
                    canRead = canWrite = canWriteWithoutResponse = false;
              } else {
                final properties = characteristic.properties;
                canNotify = properties.contains(
                      GattCharacteristicProperty.notify,
                    ) ||
                    properties.contains(
                      GattCharacteristicProperty.indicate,
                    );
                canRead = properties.contains(
                  GattCharacteristicProperty.read,
                );
                canWrite = properties.contains(
                  GattCharacteristicProperty.write,
                );
                canWriteWithoutResponse = properties.contains(
                  GattCharacteristicProperty.writeWithoutResponse,
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: characteristic != null && canNotify
                              ? () async {
                                  await centralManager
                                      .setCharacteristicNotifyState(
                                    characteristic,
                                    state: true,
                                  );
                                }
                              : null,
                          child: const Text('NOTIFY'),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: characteristic != null && canRead
                              ? () async {
                                  final value = await centralManager
                                      .readCharacteristic(characteristic);
                                  const type = LogType.read;
                                  final log = Log(type, value);
                                  logs.value = [...logs.value, log];
                                }
                              : null,
                          child: const Text('READ'),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 160.0,
                    child: TextField(
                      controller: writeController,
                      enabled: canWrite || canWriteWithoutResponse,
                      expands: true,
                      maxLines: null,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      ValueListenableBuilder(
                        valueListenable: writeType,
                        builder: (context, writeType, child) {
                          return ToggleButtons(
                            onPressed: canWrite || canWriteWithoutResponse
                                ? (i) {
                                    if (!canWrite || !canWriteWithoutResponse) {
                                      return;
                                    }
                                    final type =
                                        GattCharacteristicWriteType.values[i];
                                    this.writeType.value = type;
                                  }
                                : null,
                            constraints: const BoxConstraints(
                              minWidth: 0.0,
                              minHeight: 0.0,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                            isSelected: GattCharacteristicWriteType.values
                                .map((type) => type == writeType)
                                .toList(),
                            children: GattCharacteristicWriteType.values.map(
                              (type) {
                                return Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 4.0,
                                  ),
                                  child: Text(type.name),
                                );
                              },
                            ).toList(),
                          );
                          // final segments =
                          //     GattCharacteristicWriteType.values.map((type) {
                          //   return ButtonSegment(
                          //     value: type,
                          //     label: Text(type.name),
                          //   );
                          // }).toList();
                          // return SegmentedButton(
                          //   segments: segments,
                          //   selected: {writeType},
                          //   showSelectedIcon: false,
                          //   style: OutlinedButton.styleFrom(
                          //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          //     padding: EdgeInsets.zero,
                          //     visualDensity: VisualDensity.compact,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(8.0),
                          //     ),
                          //   ),
                          // );
                        },
                      ),
                      const Spacer(),
                      ElevatedButton(
                        onPressed: characteristic != null && canWrite
                            ? () async {
                                final text = writeController.text;
                                final elements = utf8.encode(text);
                                final value = Uint8List.fromList(elements);
                                final type = writeType.value;
                                // Fragments the value by 512 bytes.
                                const fragmentSize = 512;
                                var start = 0;
                                while (start < value.length) {
                                  final end = start + fragmentSize;
                                  final fragmentedValue = end < value.length
                                      ? value.sublist(start, end)
                                      : value.sublist(start);
                                  await centralManager.writeCharacteristic(
                                    characteristic,
                                    value: fragmentedValue,
                                    type: type,
                                  );
                                  final log = Log(
                                    LogType.write,
                                    fragmentedValue,
                                  );
                                  logs.value = [...logs.value, log];
                                  start = end;
                                }
                              }
                            : null,
                        child: const Text('WRITE'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    connectionStateChangedSubscription.cancel();
    characteristicNotifiedSubscription.cancel();
    connectionState.dispose();
    services.dispose();
    characteristics.dispose();
    service.dispose();
    characteristic.dispose();
    writeType.dispose();
    logs.dispose();
    writeController.dispose();
  }
}
