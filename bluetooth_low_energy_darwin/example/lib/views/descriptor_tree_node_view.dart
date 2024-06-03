import 'package:bluetooth_low_energy_darwin_example/view_models.dart';
import 'package:clover/clover.dart';
import 'package:flutter/material.dart';

class DescriptorTreeNodeView extends StatelessWidget {
  const DescriptorTreeNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<DescriptorViewModel>(context);
    return Text(
      '${viewModel.uuid}',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.tertiary,
          ),
    );
  }
}
