import 'package:bluetooth_low_energy_example/view_models.dart';
import 'package:clover/clover.dart';
import 'package:flutter/material.dart';

class ServiceTreeNodeView extends StatelessWidget {
  const ServiceTreeNodeView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<ServiceViewModel>(context);
    return Text(
      '${viewModel.uuid}',
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
            color: Theme.of(context).colorScheme.primary,
          ),
    );
  }
}
