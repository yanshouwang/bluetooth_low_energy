import 'package:bluetooth_low_energy_windows_example/view_models.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

class CharacteristicTreeNodeView extends StatelessWidget {
  const CharacteristicTreeNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<CharacteristicViewModel>(context);
    return Row(
      children: [
        Icon(
          Symbols.join_right,
          color: Theme.of(context).colorScheme.secondary,
        ),
        const SizedBox(width: 16.0),
        Text(
          '${viewModel.uuid}',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
        ),
      ],
    );
  }
}
