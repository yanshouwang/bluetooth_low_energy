import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final Central central;
  final Map<MAC, Discovery> discoveries;

  _HomeViewState()
      : central = Central(),
        discoveries = {};

  @override
  void initState() {
    super.initState();
    central.stopDiscovery();
    central.startDiscovery();
  }

  @override
  void dispose() {
    central.stopDiscovery();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: StreamBuilder(
          stream: central.discovered,
          builder: (context, AsyncSnapshot<Discovery> snapshot) {
            if (snapshot.hasData) {
              final data = snapshot.data!;
              discoveries[data.address] = data;
            }
            return ListView.builder(
              padding: EdgeInsets.all(6.0),
              itemCount: discoveries.length,
              itemBuilder: (context, i) {
                final discovery = discoveries.values.toList()[i];
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
                    onTap: () {
                      showModalBottomSheet(
                        shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(12.0),
                            bottomRight: Radius.circular(12.0),
                          ),
                        ),
                        context: context,
                        elevation: 1.0,
                        builder: (context) {
                          return Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children:
                                  discovery.advertisements.entries.map((entry) {
                                final key =
                                    entry.key.toRadixString(16).padLeft(2, '0');
                                final value = hex.encode(entry.value);
                                return Row(
                                  children: [
                                    Text('0x$key'),
                                    Text(
                                      '$value',
                                      softWrap: true,
                                      maxLines: 2,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          );
                        },
                      );
                    },
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
          },
        ),
      ),
    );
  }
}
