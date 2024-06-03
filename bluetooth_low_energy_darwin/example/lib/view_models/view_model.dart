import 'package:flutter/widgets.dart';

typedef ViewBuilder<T extends Widget> = T Function(BuildContext context);
typedef ViewModelBuilder<T extends ViewModel> = T Function(
    BuildContext context);

abstract class ViewModel extends ChangeNotifier {
  static T of<T extends ViewModel>(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedViewModel<T>>()!
      .viewModel;
}

class ViewModelBinding<TView extends Widget, TViewModel extends ViewModel>
    extends StatefulWidget {
  final ViewBuilder<TView> viewBuilder;
  final ViewModelBuilder<TViewModel> viewModelBuilder;

  const ViewModelBinding({
    super.key,
    required this.viewBuilder,
    required this.viewModelBuilder,
  });

  @override
  State<ViewModelBinding<TView, TViewModel>> createState() =>
      _ViewModelBindingState<TView, TViewModel>();
}

class _ViewModelBindingState<TView extends Widget, TViewModel extends ViewModel>
    extends State<ViewModelBinding<TView, TViewModel>> {
  late final TViewModel _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.viewModelBuilder(context);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedViewModel<TViewModel>(
      view: widget.viewBuilder(context),
      viewModel: _viewModel,
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

class InheritedViewModel<T extends ViewModel> extends StatelessWidget {
  final Widget view;
  final T viewModel;

  const InheritedViewModel({
    super.key,
    required this.view,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context) {
    return _InheritedViewModel<T>(
      viewModel: viewModel,
      child: view,
    );
  }
}

class _InheritedViewModel<T extends ViewModel> extends InheritedNotifier<T> {
  const _InheritedViewModel({
    super.key,
    required T viewModel,
    required super.child,
  }) : super(notifier: viewModel);

  T get viewModel => notifier!;
}
