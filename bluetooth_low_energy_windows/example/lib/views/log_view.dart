import 'package:bluetooth_low_energy_windows_example/models.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LogView extends StatelessWidget {
  final Log log;

  const LogView({
    super.key,
    required this.log,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat.Hms();
    final time = formatter.format(log.time);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            text: '[$time] ',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
            children: [
              TextSpan(
                  text: log.type,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      )),
            ],
          ),
        ),
        Text(
          log.message,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
