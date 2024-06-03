import 'package:bluetooth_low_energy/bluetooth_low_energy.dart';
import 'package:clover/clover.dart';
import 'package:collection/collection.dart';
import 'package:go_router/go_router.dart';

import 'view_models.dart';
import 'views.dart';

final routerConfig = GoRouter(
  redirect: (context, state) {
    if (state.matchedLocation == '/') {
      return '/central';
    }
    return null;
  },
  routes: [
    StatefulShellRoute(
      // builder: (context, state, navigationShell) {
      //   return HomeView(navigationShell: navigationShell);
      // },
      builder: (context, state, navigationShell) => navigationShell,
      navigatorContainerBuilder: (context, navigationShell, children) {
        final navigators = children.mapIndexed(
          (index, element) {
            if (index == 0) {
              return ViewModelBinding(
                viewBuilder: (context) => element,
                viewModelBuilder: (context) => CentralManagerViewModel(),
              );
            } else {
              return element;
            }
          },
        ).toList();
        return HomeView(
          navigationShell: navigationShell,
          navigators: navigators,
        );
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/central',
              builder: (context, state) {
                return const CentralManagerView();
              },
              routes: [
                GoRoute(
                  path: ':uuid',
                  builder: (context, state) {
                    final uuidValue = state.pathParameters['uuid']!;
                    final uuid = UUID.fromString(uuidValue);
                    final viewModel =
                        ViewModel.of<CentralManagerViewModel>(context);
                    final eventArgs = viewModel.discoveries.firstWhere(
                        (discovery) => discovery.peripheral.uuid == uuid);
                    return ViewModelBinding(
                      viewBuilder: (context) => PeripheralView(),
                      viewModelBuilder: (context) =>
                          PeripheralViewModel(eventArgs),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/peripheral',
              builder: (context, state) {
                return ViewModelBinding(
                  viewBuilder: (context) => const PeripheralManagerView(),
                  viewModelBuilder: (context) => PeripheralManagerViewModel(),
                );
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
