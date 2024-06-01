import 'dart:math' as math;

import 'package:bluetooth_low_energy_windows_example/view_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class ServiceTreeNodeView extends StatelessWidget {
  const ServiceTreeNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<ServiceViewModel>(context);
    return Row(
      children: [
        Transform.rotate(
          angle: math.pi / 2.0,
          child: Icon(
            Symbols.polymer,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(width: 16.0),
        Text(
          '${viewModel.uuid}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
      ],
    );
  }
}
