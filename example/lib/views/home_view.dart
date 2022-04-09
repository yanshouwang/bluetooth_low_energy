import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

import 'util.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final ValueNotifier<BluetoothState> stateNotifier;
  late final ValueNotifier<bool> scanningNotifier;
  late final MapNotifier<UUID, Discovery> discoveriesNotifier;
  late final EventSubscription stateChangedSubscription;
  late EventSubscription? scanSubscription;

  @override
  void initState() {
    super.initState();
    stateNotifier = ValueNotifier(BluetoothState.unsupported);
    scanningNotifier = ValueNotifier(false);
    discoveriesNotifier = MapNotifier({});
    runAsync();
  }

  Future<void> runAsync() async {
    // Make sure this app has bluetooth permissions.
    await central.authorize();
    final state = await central.getState();
    stateNotifier.value = state;
    stateChangedSubscription = await central.subscribeStateChanged(
      onStateChanged: (state) {
        stateNotifier.value = state;
        final invisible = !ModalRoute.of(context)!.isCurrent;
        if (invisible) return;
        if (stateNotifier.value == BluetoothState.poweredOn) {
          startScan();
        } else {
          stopScan();
        }
      },
    );
    if (stateNotifier.value == BluetoothState.poweredOn) {
      startScan();
    }
  }

  @override
  Widget build(BuildContext context) {
    return buildHomeView(context);
  }

  @override
  void dispose() async {
    await scanSubscription?.cancel();
    await stateChangedSubscription.cancel();
    stateNotifier.dispose();
    scanningNotifier.dispose();
    scanningNotifier.dispose();
    super.dispose();
  }

  Future<void> startScan() async {
    // final uuids = [
    //   UUID("0000ff11-0000-1000-8000-00805f9b34fb"),
    // ];
    scanSubscription = await central.scan(
      // uuids: uuids,
      onScanned: (discovery) {
        discoveriesNotifier.value[discovery.uuid] = discovery;
        discoveriesNotifier.value = {...discoveriesNotifier.value};
      },
    );
    scanningNotifier.value = true;
  }

  Future<void> stopScan() async {
    await scanSubscription?.cancel();
    discoveriesNotifier.value = {};
    scanningNotifier.value = false;
  }

  Future<void> updateDiscoveries() async {
    discoveriesNotifier.value = {};
  }

  Future<void> showAdvertisements(Discovery discovery) async {
    await showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      builder: (context) => discovery.view,
    );
  }

  Future<void> showGattView(Discovery discovery) async {
    await stopScan();
    await Navigator.of(context).pushNamed(
      'gatt',
      arguments: discovery,
    );
    await startScan();
  }
}

extension on _HomeViewState {
  Widget buildHomeView(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('蓝牙调试助手'),
      ),
      body: ValueListenableBuilder<BluetoothState>(
        valueListenable: stateNotifier,
        builder: (context, state, child) {
          switch (state) {
            case BluetoothState.unauthorized:
              return buildUnauthorizedView(context);
            case BluetoothState.poweredOff:
              return buildPoweredOffView(context);
            case BluetoothState.poweredOn:
              return buildDiscoveriesView(context);
            case BluetoothState.unsupported:
            default:
              return buildUnsupportedView(context);
          }
        },
      ),
    );
  }

  Widget buildUnsupportedView(BuildContext context) {
    return const Center(
      child: Text('Unsupported.'),
    );
  }

  Widget buildUnauthorizedView(BuildContext context) {
    return const Center(
      child: Text('Unauthorized.'),
    );
  }

  Widget buildPoweredOffView(BuildContext context) {
    return const Center(
      child: Text('Powered Off.'),
    );
  }

  Widget buildDiscoveriesView(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => await updateDiscoveries(),
      child: ValueListenableBuilder<Map<UUID, Discovery>>(
        valueListenable: discoveriesNotifier,
        builder: (context, discoveries, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(6.0),
            itemCount: discoveries.length,
            itemBuilder: (context, i) {
              final discovery = discoveries.values.elementAt(i);
              return Card(
                color: discovery.connectable ? Colors.amber : Colors.grey,
                clipBehavior: Clip.antiAlias,
                shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(12.0),
                      bottomLeft: Radius.circular(12.0)),
                ),
                margin: const EdgeInsets.all(6.0),
                key: Key(discovery.uuid.name),
                child: InkWell(
                  splashColor: Colors.purple,
                  onTap: discovery.connectable
                      ? () => showGattView(discovery)
                      : null,
                  onLongPress: () => showAdvertisements(discovery),
                  child: Container(
                    height: 100.0,
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(discovery.name ?? 'NaN'),
                              Text(
                                discovery.uuid.name,
                                softWrap: true,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            discovery.rssi.toString(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

extension on Discovery {
  Widget get view {
    final widgets = <Widget>[
      Row(
        children: const [
          Text('Type'),
          Expanded(
            child: Center(
              child: Text('Value'),
            ),
          ),
        ],
      ),
      const Divider(),
    ];
    for (final entry in advertisements.entries) {
      final key = entry.key.toRadixString(16).padLeft(2, '0');
      final value = hex.encode(entry.value);
      final widget = Row(
        children: [
          Text('0x$key'),
          Container(width: 12.0),
          Expanded(
            child: Text(
              value,
              softWrap: true,
            ),
          ),
        ],
      );
      widgets.add(widget);
      if (entry.key != advertisements.entries.last.key) {
        const divider = Divider();
        widgets.add(divider);
      }
    }
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 1.0,
        shape: const BeveledRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12.0),
            bottomRight: Radius.circular(12.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: widgets,
          ),
        ),
      ),
    );
  }
}
