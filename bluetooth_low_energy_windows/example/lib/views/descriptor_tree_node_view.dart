import 'package:bluetooth_low_energy_windows_example/view_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class DescriptorTreeNodeView extends StatelessWidget {
  const DescriptorTreeNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<DescriptorViewModel>(context);
    return Row(
      children: [
        Icon(
          Symbols.asterisk,
          color: Theme.of(context).colorScheme.tertiary,
        ),
        const SizedBox(width: 16.0),
        Text(
          '${viewModel.uuid}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.tertiary,
              ),
        ),
      ],
    );
  }
}
