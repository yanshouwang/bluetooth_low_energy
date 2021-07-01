import 'package:bluetooth_low_energy_example/widgets.dart';
import 'package:flutter/material.dart';

class FlipView extends StatelessWidget {
  final front = Container(
    height: 300,
    width: 300,
    color: Colors.orange,
    child: Center(
      child: Text('正面'),
    ),
  );
  final back = Container(
    height: 300,
    width: 300,
    color: Colors.blue,
    child: Center(
      child: Text(
        '反面',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FlipCard(
            front: front,
            back: back,
          ),
        ),
      ),
    );
  }
}
