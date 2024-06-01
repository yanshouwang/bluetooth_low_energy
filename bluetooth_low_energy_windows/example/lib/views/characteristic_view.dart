import 'dart:convert';

import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:bluetooth_low_energy_windows_example/view_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CharacteristicView extends StatefulWidget {
  const CharacteristicView({super.key});

  @override
  State<CharacteristicView> createState() => _CharacteristicViewState();
}

class _CharacteristicViewState extends State<CharacteristicView> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<CharacteristicViewModel>(context);
    final logs = viewModel.logs;
    return Column(
      children: [
        Expanded(
          child: Row(
            children: [
              Expanded(
                child: InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  child: ListView.builder(
                    itemBuilder: (context, i) {
                      final log = logs[i];
                      return Text('$log');
                    },
                    itemCount: logs.length,
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Column(
                children: [
                  Visibility(
                    visible: viewModel.canNotify,
                    child: viewModel.notifyState
                        ? IconButton.filled(
                            onPressed: () async {
                              await viewModel.setNotifyState(false);
                            },
                            icon: const Icon(Symbols.notifications_active),
                          )
                        : IconButton.filledTonal(
                            onPressed: () async {
                              await viewModel.setNotifyState(true);
                            },
                            icon: const Icon(Symbols.notifications_off),
                          ),
                  ),
                  Visibility(
                    visible: viewModel.canNotify,
                    child: const SizedBox(height: 8.0),
                  ),
                  Visibility(
                    visible: viewModel.canRead,
                    child: IconButton.filled(
                      onPressed: () async {
                        await viewModel.read();
                      },
                      icon: const Icon(Symbols.arrow_downward),
                    ),
                  ),
                  Visibility(
                    visible: viewModel.canRead,
                    child: const SizedBox(height: 8.0),
                  ),
                  Visibility(
                    visible:
                        viewModel.canWrite || viewModel.canWriteWithoutResponse,
                    child: viewModel.writeType ==
                            GATTCharacteristicWriteType.withResponse
                        ? IconButton.filled(
                            onPressed: viewModel.canWriteWithoutResponse
                                ? () {
                                    viewModel.setWriteType(
                                        GATTCharacteristicWriteType
                                            .withoutResponse);
                                  }
                                : null,
                            icon: const Icon(Symbols.swap_vert),
                          )
                        : IconButton.filledTonal(
                            onPressed: viewModel.canWrite
                                ? () {
                                    viewModel.setWriteType(
                                        GATTCharacteristicWriteType
                                            .withResponse);
                                  }
                                : null,
                            icon: const Icon(Symbols.arrow_upward),
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Visibility(
          visible: viewModel.canWrite || viewModel.canWriteWithoutResponse,
          child: const SizedBox(height: 8.0),
        ),
        Visibility(
          visible: viewModel.canWrite || viewModel.canWriteWithoutResponse,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    isDense: true,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ValueListenableBuilder(
                valueListenable: _textController,
                builder: (context, tev, child) {
                  final text = tev.text;
                  return IconButton.filled(
                    onPressed: text.isEmpty
                        ? null
                        : () async {
                            final value = utf8.encode(text);
                            await viewModel.write(value);
                          },
                    icon: const Icon(Symbols.pets),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
