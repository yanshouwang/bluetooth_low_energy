import 'dart:async';

import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {
  final ValueNotifier<bool> discovering;
  final ValueNotifier<Map<UUID, Discovery>> discoveries;
  late StreamSubscription<bool> stateSubscription;
  late StreamSubscription<Discovery> discoverySubscription;

  _HomeViewState()
      : discovering = ValueNotifier(false),
        discoveries = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    stateSubscription = central.stateChanged.listen((state) {
      if (state) {
        startDiscovery();
      } else {
        discoveries.value = {};
        discovering.value = false;
      }
    });
    discoverySubscription = central.discovered.listen(
      (discovery) {
        discoveries.value[discovery.uuid] = discovery;
        discoveries.value = {...discoveries.value};
      },
    );
    startDiscovery();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    stopDiscovery();
    stateSubscription.cancel();
    discoverySubscription.cancel();
    discoveries.dispose();
    discovering.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    print('dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: bodyView,
    );
  }

  void startDiscovery() async {
    final state = await central.state;
    if (!state) return;
    await central.startDiscovery();
    discovering.value = true;
  }

  void stopDiscovery() async {
    final state = await central.state;
    if (!state) return;
    await central.stopDiscovery();
    discovering.value = false;
  }

  void showAdvertisements(Discovery discovery) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      builder: (context) => buildAdvertisementsView(discovery),
    );
  }

  void showGattView(Discovery discovery) async {
    stopDiscovery();
    await Navigator.of(context).pushNamed(
      'gatt',
      arguments: discovery.uuid,
    );
    startDiscovery();
  }
}

extension on _HomeViewState {
  Widget get bodyView {
    return FutureBuilder<bool>(
      future: central.state,
      builder: (context, snapshot) => snapshot.hasData
          ? StreamBuilder<bool>(
              stream: central.stateChanged,
              initialData: snapshot.data,
              builder: (context, snapshot) =>
                  snapshot.data! ? discoveriesView : closedView,
            )
          : closedView,
    );
  }

  Widget get closedView {
    return Center(
      child: Text('蓝牙未开启'),
    );
  }

  Widget get discoveriesView {
    return RefreshIndicator(
      onRefresh: () async => discoveries.value = {},
      child: ValueListenableBuilder(
        valueListenable: discoveries,
        builder: (context, Map<UUID, Discovery> discoveries, child) {
          return ListView.builder(
            padding: EdgeInsets.all(6.0),
            itemCount: discoveries.length,
            itemBuilder: (context, i) {
              final discovery = discoveries.values.elementAt(i);
              return Card(
                color: Colors.amber,
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
                  onTap: () => showGattView(discovery),
                  onLongPress: () => showAdvertisements(discovery),
                  child: Container(
                    height: 100.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(discovery.name ?? 'NaN'),
                            Text(discovery.uuid.name),
                          ],
                        ),
                        Text(discovery.rssi.toString()),
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

  Widget buildAdvertisementsView(Discovery discovery) {
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
    for (final entry in discovery.advertisements.entries) {
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
      if (entry.key != discovery.advertisements.entries.last.key) {
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
