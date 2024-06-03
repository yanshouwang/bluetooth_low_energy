import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
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
    return LayoutBuilder(
      builder: (context, constraints) {
        const idWidth = 100.0;
        final valueWidth = constraints.maxWidth - idWidth - 16.0 * 2.0;
        return DataTable(
          columnSpacing: 0.0,
          horizontalMargin: 16.0,
          columns: [
            DataColumn(
              label: Container(
                width: idWidth,
                alignment: Alignment.center,
                child: const Text('Id'),
              ),
            ),
            DataColumn(
              label: Container(
                width: valueWidth,
                alignment: Alignment.center,
                child: const Text('Value'),
              ),
            ),
          ],
          rows: manufacturerSpecificData.map((item) {
            final id = '0x${item.id.toRadixString(16).padLeft(4, '0')}';
            final value = hex.encode(item.data);
            return DataRow(
              cells: [
                DataCell(
                  Container(
                    width: idWidth,
                    alignment: Alignment.center,
                    child: Text(id),
                  ),
                ),
                DataCell(
                  Container(
                    width: valueWidth,
                    alignment: Alignment.center,
                    child: Text(
                      value,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
