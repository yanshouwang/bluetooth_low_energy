import 'dart:convert';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_windows_example/view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart' hide ConnectionState;
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';
import 'package:hybrid_logging/hybrid_logging.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class PeripheralView extends StatefulWidget {
  const PeripheralView({super.key});

  @override
  State<PeripheralView> createState() => _PeripheralViewState();
}

class _PeripheralViewState extends State<PeripheralView>
    with RouteAware, TypeLogger {
  late final ValueNotifier<GATTService?> service;
  late final ValueNotifier<GATTCharacteristic?> characteristic;
  late final ValueNotifier<GATTCharacteristicWriteType> writeType;
  late final TextEditingController writeController;

  @override
  void initState() {
    super.initState();
    service = ValueNotifier(null);
    characteristic = ValueNotifier(null);
    writeType = ValueNotifier(GATTCharacteristicWriteType.withResponse);
    writeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<PeripheralViewModel>(context);
    final connected = viewModel.connected;
    final services = viewModel.services;
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.name ?? '${viewModel.uuid}'),
        actions: [
          TextButton(
            onPressed: () async {
              if (connected) {
                await viewModel.disconnect();
              } else {
                await viewModel.connect();
                await viewModel.discoverGATT();
              }
            },
            child: Text(connected ? 'DISCONNECT' : 'CONNECT'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: TreeView(
          nodes: services.map((service) {
            final characteristics = service.characteristics;
            return TreeNode(
              children: characteristics.map((characteristic) {
                final descriptors = characteristic.descriptors;
                return TreeNode(
                  children: descriptors.map((descriptor) {
                    return TreeNode(
                      content: Row(
                        children: [
                          Icon(
                            Symbols.asterisk,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                          const SizedBox(width: 12.0),
                          Text(
                            '${descriptor.uuid}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.tertiary,
                                ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  content: Row(
                    children: [
                      Icon(
                        Symbols.join_right,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      const SizedBox(width: 12.0),
                      Text(
                        '${characteristic.uuid}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                      ),
                      Offstage(
                        offstage: characteristic.properties.none((property) =>
                            property == GATTCharacteristicProperty.read),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Symbols.arrow_downward),
                        ),
                      ),
                      Offstage(
                        offstage: characteristic.properties.none((property) =>
                            property ==
                            GATTCharacteristicProperty.writeWithoutResponse),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Symbols.arrow_upward),
                        ),
                      ),
                      Offstage(
                        offstage: characteristic.properties.none((property) =>
                            property == GATTCharacteristicProperty.write),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Symbols.swap_vert),
                        ),
                      ),
                      Offstage(
                        offstage: characteristic.properties.none((property) =>
                            property == GATTCharacteristicProperty.notify ||
                            property == GATTCharacteristicProperty.indicate),
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(Symbols.notifications_off),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              content: Row(
                children: [
                  Transform.rotate(
                    angle: math.pi / 2.0,
                    child: Icon(
                      Symbols.polymer,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  Text(
                    '${service.uuid}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget buildCharacteristicView(
      BuildContext context, GATTCharacteristic characteristic) {
    return Container();
  }

  Widget buildBody(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = ViewModel.of<PeripheralViewModel>(context);
    final services = viewModel.services;
    final logs = viewModel.logs;
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ValueListenableBuilder(
            valueListenable: service,
            builder: (context, service, child) {
              return DropdownButton(
                isExpanded: true,
                items: services.map((service) {
                  return DropdownMenuItem(
                    value: service,
                    child: Text(
                      '${service.uuid}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  );
                }).toList(),
                hint: const Text('CHOOSE A SERVICE'),
                value: service,
                onChanged: (service) async {
                  this.service.value = service;
                  characteristic.value = null;
                },
              );
            },
          ),
          ValueListenableBuilder(
            valueListenable: service,
            builder: (context, service, child) {
              return ValueListenableBuilder(
                valueListenable: characteristic,
                builder: (context, characteristic, child) {
                  return DropdownButton(
                    isExpanded: true,
                    items: service?.characteristics.map((characteristic) {
                      return DropdownMenuItem(
                        value: characteristic,
                        child: Text(
                          '${characteristic.uuid}',
                          style: theme.textTheme.bodyMedium,
                        ),
                      );
                    }).toList(),
                    hint: const Text('CHOOSE A CHARACTERISTIC'),
                    value: characteristic,
                    onChanged: (characteristic) {
                      if (characteristic == null) {
                        return;
                      }
                      this.characteristic.value = characteristic;
                      final writeType = this.writeType.value;
                      final canWrite = characteristic.properties.contains(
                        GATTCharacteristicProperty.write,
                      );
                      final canWriteWithoutResponse =
                          characteristic.properties.contains(
                        GATTCharacteristicProperty.writeWithoutResponse,
                      );
                      if (writeType ==
                              GATTCharacteristicWriteType.withResponse &&
                          !canWrite &&
                          canWriteWithoutResponse) {
                        this.writeType.value =
                            GATTCharacteristicWriteType.withoutResponse;
                      }
                      if (writeType ==
                              GATTCharacteristicWriteType.withoutResponse &&
                          !canWriteWithoutResponse &&
                          canWrite) {
                        this.writeType.value =
                            GATTCharacteristicWriteType.withResponse;
                      }
                    },
                  );
                },
              );
            },
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, i) {
                final log = logs[i];
                return Text('$log');
              },
              itemCount: logs.length,
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
                      GATTCharacteristicProperty.notify,
                    ) ||
                    properties.contains(
                      GATTCharacteristicProperty.indicate,
                    );
                canRead = properties.contains(
                  GATTCharacteristicProperty.read,
                );
                canWrite = properties.contains(
                  GATTCharacteristicProperty.write,
                );
                canWriteWithoutResponse = properties.contains(
                  GATTCharacteristicProperty.writeWithoutResponse,
                );
              }
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: characteristic != null && canNotify
                            ? () async {
                                await viewModel.setCharacteristicNotifyState(
                                  characteristic,
                                  state: true,
                                );
                              }
                            : null,
                        child: const Text('NOTIFY'),
                      ),
                      ElevatedButton(
                        onPressed: characteristic != null && canRead
                            ? () async {
                                await viewModel
                                    .readCharacteristic(characteristic);
                              }
                            : null,
                        child: const Text('READ'),
                      )
                    ],
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
                                        GATTCharacteristicWriteType.values[i];
                                    this.writeType.value = type;
                                  }
                                : null,
                            constraints: const BoxConstraints(
                              minWidth: 0.0,
                              minHeight: 0.0,
                            ),
                            borderRadius: BorderRadius.circular(4.0),
                            isSelected: GATTCharacteristicWriteType.values
                                .map((type) => type == writeType)
                                .toList(),
                            children: GATTCharacteristicWriteType.values.map(
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
                          //     GATTCharacteristicWriteType.values.map((type) {
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
                                await viewModel.writeCharacteristic(
                                  characteristic,
                                  value: value,
                                  type: type,
                                );
                              }
                            : null,
                        child: const Text('WRITE'),
                      ),
                    ],
                  ),
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
    service.dispose();
    characteristic.dispose();
    writeType.dispose();
    writeController.dispose();
  }
}
