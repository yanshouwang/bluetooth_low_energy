import 'package:bluetooth_low_energy_windows_example/view_models.dart';
import 'package:clover/clover.dart';
import 'package:flutter/material.dart';

class CharacteristicTreeNodeView extends StatelessWidget {
  const CharacteristicTreeNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<CharacteristicViewModel>(context);
    return Text(
      '${viewModel.uuid}',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.secondary,
          ),
    );
  }
}
