import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';

class AdvertisementView extends StatelessWidget {
  final Advertisement advertisement;

  const AdvertisementView({
    super.key,
    required this.advertisement,
  });

  @override
  Widget build(BuildContext context) {
    final manufacturerSpecificData = advertisement.manufacturerSpecificData;
    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 16.0,
        vertical: 40.0,
      ),
      itemBuilder: (context, i) {
        const idWidth = 80.0;
        if (i == 0) {
          return const Row(
            children: [
              SizedBox(
                width: idWidth,
                child: Center(
                  child: Text('Id'),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text('Data'),
                ),
              ),
            ],
          );
        } else {
          final item = manufacturerSpecificData[i - 1];
          final id = '0x${item.id.toRadixString(16).padLeft(4, '0')}';
          final value = hex.encode(item.data);
          return Row(
            children: [
              SizedBox(
                width: idWidth,
                child: Center(
                  child: Text(id),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text(value),
                ),
              ),
            ],
          );
        }
      },
      separatorBuilder: (context, i) {
        return const Divider();
      },
      itemCount: manufacturerSpecificData.length + 1,
    );
  }
}
