import 'dart:async';
import 'dart:convert';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GattView extends StatefulWidget {
  const GattView({Key? key}) : super(key: key);

  @override
  _GattViewState createState() => _GattViewState();
}

class _GattViewState extends State<GattView> {
  final ValueNotifier<ConnectionState> state;
  GATT? gatt;
  StreamSubscription? connectionLostSubscription;
  final ValueNotifier<GattService?> service;
  final ValueNotifier<GattCharacteristic?> characteristic;
  final TextEditingController writeController;
  final ValueNotifier<Map<GattCharacteristic, StreamSubscription>> notifies;
  final ValueNotifier<List<String>> logs;

  late UUID uuid;

  _GattViewState()
      : state = ValueNotifier(ConnectionState.disconnected),
        service = ValueNotifier(null),
        characteristic = ValueNotifier(null),
        writeController = TextEditingController(),
        notifies = ValueNotifier({}),
        logs = ValueNotifier([]);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    uuid = ModalRoute.of(context)!.settings.arguments as UUID;
    return Scaffold(
      appBar: AppBar(
        title: Text(uuid.name),
        actions: [
          connectionView,
        ],
      ),
      body: bodyView,
    );
  }

  void Function()? disposeListener;

  @override
  void dispose() {
    super.dispose();

    if (state.value != ConnectionState.disconnected) {
      disposeListener ??= () => disposeGATT();
      state.addListener(disposeListener!);
      if (state.value == ConnectionState.connected) {
        disconnect();
      }
    } else {
      state.dispose();
      service.dispose();
      characteristic.dispose();
      notifies.dispose();
      logs.dispose();
    }
  }

  void disposeGATT() {
    switch (state.value) {
      case ConnectionState.connected:
        disconnect();
        break;
      case ConnectionState.disconnected:
        state.removeListener(disposeListener!);
        state.dispose();
        service.dispose();
        characteristic.dispose();
        notifies.dispose();
        logs.dispose();
        break;
      default:
        break;
    }
  }

  void connect() async {
    try {
      state.value = ConnectionState.connecting;
      gatt = await central.connect(uuid);
      state.value = ConnectionState.connected;
      connectionLostSubscription = gatt!.connectionLost.listen(
        (errorCode) async {
          for (var subscription in notifies.value.values) {
            await subscription.cancel();
          }
          await connectionLostSubscription!.cancel();
          gatt = null;
          connectionLostSubscription = null;
          service.value = null;
          characteristic.value = null;
          notifies.value.clear();
          logs.value.clear();
          state.value = ConnectionState.disconnected;
        },
      );
    } on PlatformException {
      state.value = ConnectionState.disconnected;
    }
  }

  void disconnect() async {
    try {
      state.value = ConnectionState.disconnecting;
      await gatt!.disconnect();
      for (var subscription in notifies.value.values) {
        await subscription.cancel();
      }
      await connectionLostSubscription!.cancel();
      gatt = null;
      connectionLostSubscription = null;
      service.value = null;
      characteristic.value = null;
      notifies.value.clear();
      logs.value.clear();
      state.value = ConnectionState.disconnected;
    } on PlatformException {
      state.value = ConnectionState.connected;
    }
  }
}

enum ConnectionState {
  disconnected,
  connecting,
  connected,
  disconnecting,
}

extension on _GattViewState {
  Widget get connectionView {
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (context, ConnectionState stateValue, child) {
        void Function()? onPressed;
        var data = '';
        switch (stateValue) {
          case ConnectionState.disconnected:
            onPressed = connect;
            data = '连接';
            break;
          case ConnectionState.connected:
            onPressed = disconnect;
            data = '断开';
            break;
          default:
            break;
        }
        return TextButton(
          onPressed: onPressed,
          child: Text(
            data,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget get bodyView {
    return ValueListenableBuilder(
      valueListenable: state,
      builder: (context, ConnectionState stateValue, child) {
        switch (stateValue) {
          case ConnectionState.disconnected:
            return disconnectedView;
          case ConnectionState.connecting:
            return connectingView;
          case ConnectionState.connected:
            return connectedView;
          case ConnectionState.disconnecting:
            return disconnectingView;
          default:
            throw UnimplementedError();
        }
      },
    );
  }

  Widget get disconnectedView {
    return Center(
      child: Text('未连接'),
    );
  }

  Widget get connectingView {
    return Center(
      child: Text('正在建立连接'),
    );
  }

  Widget get connectedView {
    return ValueListenableBuilder(
      valueListenable: service,
      builder: (context, GattService? serviceValue, child) {
        final services = gatt!.services.values
            .map((service) => DropdownMenuItem<GattService>(
                  value: service,
                  child: Text(
                    service.uuid.name,
                    softWrap: false,
                  ),
                ))
            .toList();
        final serviceView = DropdownButton<GattService>(
          isExpanded: true,
          hint: Text('选择服务'),
          value: serviceValue,
          items: services,
          onChanged: (value) {
            service.value = value;
            characteristic.value = null;
          },
        );
        final views = <Widget>[serviceView];
        if (serviceValue != null) {
          final characteristics = serviceValue.characteristics.values
              .map((characteristic) => DropdownMenuItem(
                    value: characteristic,
                    child: Text(
                      characteristic.uuid.name,
                      softWrap: false,
                    ),
                  ))
              .toList();
          final characteristicView = ValueListenableBuilder(
            valueListenable: characteristic,
            builder: (context, GattCharacteristic? characteristicValue, child) {
              final canWrite = characteristicValue != null &&
                  (characteristicValue.canWrite ||
                      characteristicValue.canWriteWithoutResponse);
              final canRead =
                  characteristicValue != null && characteristicValue.canRead;
              final canNotify =
                  characteristicValue != null && characteristicValue.canNotify;
              final readAndNotifyView = Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: canRead
                        ? () async {
                            final value = await characteristicValue!.read();
                            final time = DateTime.now().display;
                            final log = '[$time][READ] ${hex.encode(value)}';
                            logs.value = [...logs.value, log];
                          }
                        : null,
                    icon: Icon(Icons.archive),
                  ),
                  ValueListenableBuilder(
                      valueListenable: notifies,
                      builder: (context,
                          Map<GattCharacteristic, StreamSubscription>
                              notifiesValue,
                          child) {
                        final notifying =
                            notifiesValue.containsKey(characteristicValue);
                        return IconButton(
                          onPressed: canNotify
                              ? () async {
                                  if (notifying) {
                                    await characteristicValue!.notify(false);
                                    await notifiesValue
                                        .remove(characteristicValue)!
                                        .cancel();
                                  } else {
                                    await characteristicValue!.notify(true);
                                    notifiesValue[characteristicValue] =
                                        characteristicValue.valueChanged
                                            .listen((value) {
                                      final time = DateTime.now().display;
                                      final log =
                                          '[$time][NOTIFY] ${hex.encode(value)}';
                                      logs.value = [...logs.value, log];
                                    });
                                  }
                                  notifies.value = {...notifiesValue};
                                }
                              : null,
                          icon: Icon(
                            Icons.notifications,
                            color: notifying ? Colors.blue : null,
                          ),
                        );
                      }),
                ],
              );
              final controllerView = TextField(
                controller: writeController,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: canWrite
                        ? () {
                            final value = utf8.encode(writeController.text);
                            final withoutResponse =
                                !characteristicValue!.canWrite;
                            characteristicValue.write(value,
                                withoutResponse: withoutResponse);
                          }
                        : null,
                    icon: Icon(Icons.send),
                  ),
                ),
              );
              return Column(
                children: [
                  DropdownButton<GattCharacteristic>(
                    isExpanded: true,
                    hint: Text('选择特征值'),
                    value: characteristicValue,
                    items: characteristics,
                    onChanged: (value) => characteristic.value = value,
                  ),
                  readAndNotifyView,
                  controllerView,
                ],
              );
            },
          );
          views.add(characteristicView);
        }
        final loggerView = Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: ValueListenableBuilder(
                valueListenable: logs,
                builder: (context, List<String> logsValue, child) {
                  return ListView.builder(
                    itemCount: logsValue.length,
                    itemBuilder: (context, i) {
                      final log = logsValue[i];
                      return Text(log);
                    },
                  );
                }),
          ),
        );
        views.add(loggerView);
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: views,
          ),
        );
      },
    );
  }

  Widget get disconnectingView {
    return Center(
      child: Text('正在断开连接'),
    );
  }
}

extension on DateTime {
  String get display {
    final hh = hour.toString().padLeft(2, '0');
    final mm = minute.toString().padLeft(2, '0');
    final ss = second.toString().padLeft(2, '0');
    return '$hh:$mm:$ss';
  }
}
