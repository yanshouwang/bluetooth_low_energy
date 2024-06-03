import 'package:bluetooth_low_energy_darwin_example/view_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_simple_treeview/flutter_simple_treeview.dart';

import 'characteristic_tree_node_view.dart';
import 'characteristic_view.dart';
import 'descriptor_tree_node_view.dart';
import 'service_tree_node_view.dart';

class PeripheralView extends StatelessWidget {
  final TreeController _treeController;

  PeripheralView({super.key})
      : _treeController = TreeController(
          allNodesExpanded: false,
        );

  @override
  Widget build(BuildContext context) {
    final viewModel = ViewModel.of<PeripheralViewModel>(context);
    final connected = viewModel.connected;
    final serviceViewModels = viewModel.serviceViewModels;
    return Scaffold(
      appBar: AppBar(
        title: Text(viewModel.name ?? '${viewModel.uuid}'),
        actions: [
          TextButton(
            onPressed: () async {
              if (connected) {
                await viewModel.disconnect();
              } else {
                await viewModel.connect();
                await viewModel.discoverGATT();
              }
            },
            child: Text(connected ? 'DISCONNECT' : 'CONNECT'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: TreeView(
          treeController: _treeController,
          indent: 0.0,
          nodes: _buildServiceTreeNodes(serviceViewModels),
        ),
      ),
    );
  }

  List<TreeNode> _buildServiceTreeNodes(List<ServiceViewModel> viewModels) {
    return viewModels.map((viewModel) {
      final includedServiceViewModels = viewModel.includedServiceViewModels;
      final characteristicViewModels = viewModel.characteristicViewModels;
      return TreeNode(
        children: [
          ..._buildServiceTreeNodes(includedServiceViewModels),
          ..._buildCharacteristicTreeNodes(characteristicViewModels),
        ],
        content: InheritedViewModel(
          view: const ServiceTreeNodeView(),
          viewModel: viewModel,
        ),
      );
    }).toList();
  }

  List<TreeNode> _buildCharacteristicTreeNodes(
      List<CharacteristicViewModel> viewModels) {
    return viewModels.map((viewModel) {
      final descriptorViewModels = viewModel.descriptorViewModels;
      return TreeNode(
        children: [
          TreeNode(
            content: Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 40.0),
                height: 360.0,
                child: InheritedViewModel(
                  view: const CharacteristicView(),
                  viewModel: viewModel,
                ),
              ),
            ),
          ),
          ..._buildDescriptorTreeNodes(descriptorViewModels),
        ],
        content: InheritedViewModel(
          view: const CharacteristicTreeNodeView(),
          viewModel: viewModel,
        ),
      );
    }).toList();
  }

  List<TreeNode> _buildDescriptorTreeNodes(
      List<DescriptorViewModel> viewModels) {
    return viewModels.map((viewModel) {
      return TreeNode(
        content: InheritedViewModel(
          view: const DescriptorTreeNodeView(),
          viewModel: viewModel,
        ),
      );
    }).toList();
  }
}
