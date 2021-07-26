import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:bluetooth_low_energy_example/states/map_notifier.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ValueNotifier<bool> state;
  final ValueNotifier<bool> discovering;
  final MapNotifier<UUID, Discovery> discoveries;
  late StreamSubscription<BluetoothState> stateSubscription;
  late StreamSubscription<Discovery> discoverySubscription;

  _HomeViewState()
      : state = ValueNotifier(false),
        discovering = ValueNotifier(false),
        discoveries = MapNotifier({});

  @override
  void initState() {
    super.initState();
    setup();
  }

  @override
  Widget build(BuildContext context) => view;

  @override
  void dispose() {
    stopDiscovery();
    state.dispose();
    discovering.dispose();
    discovering.dispose();
    stateSubscription.cancel();
    discoverySubscription.cancel();
    super.dispose();
  }

  Future<void> setup() async {
    final state = await central.state;
    this.state.value = state == BluetoothState.poweredOn;
    stateSubscription = central.stateChanged.listen(
      (state) {
        this.state.value = state == BluetoothState.poweredOn;
        final invisible = !ModalRoute.of(context)!.isCurrent;
        if (invisible) return;
        if (this.state.value) {
          startDiscovery();
        } else {
          discovering.value = false;
        }
      },
    );
    discoverySubscription = central.discovered.listen(
      (discovery) {
        discoveries.value[discovery.uuid] = discovery;
        discoveries.value = {...discoveries.value};
      },
    );
    if (this.state.value) {
      startDiscovery();
    }
  }

  Future<void> startDiscovery() async {
    if (discovering.value || !state.value) return;
    await central.startDiscovery();
    discovering.value = true;
  }

  Future<void> stopDiscovery() async {
    if (!discovering.value || !state.value) return;
    await central.stopDiscovery();
    discoveries.value = {};
    discovering.value = false;
  }

  Future<void> updateDiscoveries() async {
    discoveries.value = {};
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
    await stopDiscovery();
    await Navigator.of(context).pushNamed(
      'gatt',
      arguments: discovery,
    );
    await startDiscovery();
  }
}

extension on _HomeViewState {
  Widget get view => Scaffold(
        appBar: AppBar(
          title: Text('蓝牙调试助手'),
        ),
        body: ValueListenableBuilder(
          valueListenable: state,
          builder: (context, bool state, child) =>
              state ? discoveriesView : closedView,
        ),
      );

  Widget get closedView => Center(
        child: Text('蓝牙未开启'),
      );

  Widget get discoveriesView => RefreshIndicator(
        onRefresh: () async => await updateDiscoveries(),
        child: ValueListenableBuilder(
          valueListenable: discoveries,
          builder: (context, Map<UUID, Discovery> discoveries, child) {
            return ListView.builder(
              padding: EdgeInsets.all(6.0),
              itemCount: discoveries.length,
              itemBuilder: (context, i) {
                final discovery = discoveries.values.elementAt(i);
                return Card(
                  color: discovery.connectable ? Colors.amber : Colors.grey,
                  clipBehavior: Clip.antiAlias,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12.0),
                        bottomLeft: Radius.circular(12.0)),
                  ),
                  margin: EdgeInsets.all(6.0),
                  key: Key(discovery.uuid.name),
                  child: InkWell(
                    splashColor: Colors.purple,
                    onTap: discovery.connectable
                        ? () => showGattView(discovery)
                        : null,
                    onLongPress: () => showAdvertisements(discovery),
                    child: Container(
                      height: 100.0,
                      padding: EdgeInsets.all(12.0),
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

extension on Discovery {
  Widget get view {
    final widgets = <Widget>[
      Row(
        children: [
          Text('Type'),
          Expanded(
            child: Center(
              child: Text('Value'),
            ),
          ),
        ],
      ),
      Divider(),
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
              '$value',
              softWrap: true,
            ),
          ),
        ],
      );
      widgets.add(widget);
      if (entry.key != advertisements.entries.last.key) {
        final divider = Divider();
        widgets.add(divider);
      }
    }
    return Container(
      margin: const EdgeInsets.all(12.0),
      child: Material(
        elevation: 1.0,
        shape: BeveledRectangleBorder(
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
