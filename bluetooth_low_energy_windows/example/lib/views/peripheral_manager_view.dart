import 'package:flutter/material.dart';

class PeripheralManagerView extends StatelessWidget {
  const PeripheralManagerView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
    );
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Peripheral Manager'),
    );
  }

  Widget buildBody(BuildContext context) {
    return const Center(
      child: Text('Unimplemented'),
    );
  }
}
