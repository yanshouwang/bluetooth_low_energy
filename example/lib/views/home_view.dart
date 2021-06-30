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
  final ValueNotifier<Map<MAC, Discovery>> discoveries;
  late StreamSubscription<Discovery> discoverySubscription;
  late StreamSubscription<bool> scanningSubscription;

  _HomeViewState()
      : discovering = ValueNotifier(false),
        discoveries = ValueNotifier({});

  @override
  void initState() {
    super.initState();
    print('initState');
    WidgetsBinding.instance!.addObserver(this);
    discoverySubscription = central.discovered.listen(
      (discovery) {
        discoveries.value[discovery.address] = discovery;
        var entries = discoveries.value.entries.toList();
        entries.sort((a, b) => b.value.rssi.compareTo(a.value.rssi));
        discoveries.value = Map.fromEntries(entries);
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('didChangeDependencies');
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('didUpdateWidget');
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    print('didChangeAppLifecycleState: $state');
    switch (state) {
      case AppLifecycleState.detached:
        break;
      default:
    }
  }

  @override
  void dispose() {
    discoverySubscription.cancel();
    scanningSubscription.cancel();
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
      body: ValueListenableBuilder(
        valueListenable: discoveries,
        builder: (context, Map<MAC, Discovery> discoveries, child) =>
            buildDiscoveriesView(discoveries),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (discovering.value) {
            await central.stopDiscovery();
          } else {
            discoveries.value = {};
            await central.startDiscovery();
          }
        },
        child: ValueListenableBuilder(
          valueListenable: discovering,
          builder: (context, bool scanning, child) {
            return scanning ? Icon(Icons.stop) : Icon(Icons.play_arrow);
          },
        ),
      ),
    );
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
    if (discovering.value) {
      await central.stopDiscovery();
    }
    await Navigator.of(context).pushNamed(
      'gatt',
      arguments: discovery.address,
    );
  }
}

extension on _HomeViewState {
  Widget buildDiscoveriesView(Map<MAC, Discovery> discoveries) {
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
          key: Key(discovery.address.name),
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
                      Text(discovery.address.name),
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
