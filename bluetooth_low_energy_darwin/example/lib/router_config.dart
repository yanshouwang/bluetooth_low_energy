import 'package:bluetooth_low_energy_platform_interface/bluetooth_low_energy_platform_interface.dart';
import 'package:go_router/go_router.dart';

import 'views.dart';

final routerConfig = GoRouter(
  initialLocation: '/central-manager',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return HomeView(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/central-manager',
              builder: (context, state) {
                return const CentralManagerView();
              },
              routes: [
                GoRoute(
                  path: 'peripheral',
                  builder: (context, state) {
                    final eventArgs = state.extra as DiscoveredEventArgs;
                    return PeripheralView(
                      eventArgs: eventArgs,
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
              path: '/peripheral-manager',
              builder: (context, state) {
                return const PeripheralManagerView();
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
