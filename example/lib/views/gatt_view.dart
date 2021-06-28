import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GattView extends StatefulWidget {
  const GattView({Key? key}) : super(key: key);

  @override
  _GattViewState createState() => _GattViewState();
}

class _GattViewState extends State<GattView> {
  late MAC address;
  final ValueNotifier<ConnectionState> state;
  final ValueNotifier<GATT?> gatt;
  final ValueNotifier<GattService?> service;
  final ValueNotifier<GattCharacteristic?> characteristic;

  _GattViewState()
      : state = ValueNotifier(ConnectionState.disconnected),
        gatt = ValueNotifier(null),
        service = ValueNotifier(null),
        characteristic = ValueNotifier(null);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    address = ModalRoute.of(context)!.settings.arguments as MAC;
    return Scaffold(
      appBar: AppBar(
        title: Text('GATT'),
        actions: [
          TextButton(
            onPressed: () {
              switch (state.value) {
                case ConnectionState.disconnected:
                  connect();
                  break;
                case ConnectionState.connected:
                  disconnect();
                  break;
                default:
                  break;
              }
            },
            child: ValueListenableBuilder(
              valueListenable: state,
              builder: (context, ConnectionState state, child) {
                return Text(
                  state == ConnectionState.connected ? '断开' : '连接',
                  style: TextStyle(color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: state,
        builder: (context, ConnectionState state, child) {
          switch (state) {
            case ConnectionState.disconnected:
              return Center(child: Text('未连接'));
            case ConnectionState.connecting:
              return Center(child: Text('正在建立连接'));
            case ConnectionState.connected:
              return ValueListenableBuilder(
                valueListenable: service,
                builder: (context, GattService? serviceValue, child) {
                  final services = gatt.value!.services.values
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
                      builder: (context,
                          GattCharacteristic? characteristicValue, child) {
                        final dropdownView = DropdownButton<GattCharacteristic>(
                          isExpanded: true,
                          hint: Text('选择特征值'),
                          value: characteristicValue,
                          items: characteristics,
                          onChanged: (value) => characteristic.value = value,
                        );
                        final views = <Widget>[dropdownView];
                        if (characteristicValue != null) {
                          final chipsView = Wrap(
                            spacing: 8.0,
                            runSpacing: 8.0,
                            children: [
                              Chip(
                                label: Text('Read'),
                                backgroundColor: characteristicValue.canRead
                                    ? Colors.amber
                                    : Colors.grey,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Chip(
                                label: Text('Write'),
                                backgroundColor: characteristicValue.canWrite
                                    ? Colors.amber
                                    : Colors.grey,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Chip(
                                label: Text('WriteWithoutResponse'),
                                backgroundColor:
                                    characteristicValue.canWriteWithoutResponse
                                        ? Colors.amber
                                        : Colors.grey,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                              Chip(
                                label: Text('Notify'),
                                backgroundColor: characteristicValue.canNotify
                                    ? Colors.amber
                                    : Colors.grey,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          );
                          views.add(chipsView);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: views,
                        );
                      },
                    );
                    views.add(characteristicView);
                  }
                  final logView = Expanded(
                    child: Text(''),
                  );
                  views.add(logView);
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: views,
                    ),
                  );
                },
              );
            case ConnectionState.disconnecting:
              return Center(child: Text('正在断开连接'));
            default:
              throw UnimplementedError();
          }
        },
      ),
    );
  }

  void connect() async {
    try {
      state.value = ConnectionState.connecting;
      gatt.value = await central.connect(address);
      state.value = ConnectionState.connected;
      await gatt.value!.connectionLost.first;
      state.value = ConnectionState.disconnected;
    } on PlatformException {
      state.value = ConnectionState.disconnected;
    }
  }

  void disconnect() async {
    try {
      await gatt.value!.disconnect();
      gatt.value = null;
      service.value = null;
      characteristic.value = null;
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
