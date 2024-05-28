import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeView extends StatefulWidget {
  final StatefulNavigationShell navigationShell;
  final List<Widget> navigators;

  const HomeView({
    super.key,
    required this.navigationShell,
    required this.navigators,
  });

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(
      initialPage: widget.navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navigationShell = widget.navigationShell;
    final navigators = widget.navigators;
    return Scaffold(
      // body: navigationShell,
      // body: AnimatedBranchContainer(
      //   currentIndex: widget.navigationShell.currentIndex,
      //   children: widget.children,
      // ),
      body: PageView.builder(
        controller: _controller,
        onPageChanged: (index) {
          // Ignore tap events.
          if (index == navigationShell.currentIndex) {
            return;
          }
          navigationShell.goBranch(
            index,
            initialLocation: false,
          );
        },
        itemBuilder: (context, index) {
          return navigators[index];
        },
        itemCount: navigators.length,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.radar),
            label: 'Central',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sensors),
            label: 'Peripheral',
          ),
        ],
        currentIndex: widget.navigationShell.currentIndex,
      ),
    );
  }

  @override
  void didUpdateWidget(covariant HomeView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final navigationShell = widget.navigationShell;
    final page = _controller.page ?? _controller.initialPage;
    final index = page.round();
    // Ignore swipe events.
    if (index == navigationShell.currentIndex) {
      return;
    }
    _controller.animateToPage(
      navigationShell.currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.linear,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class AnimatedBranchContainer extends StatelessWidget {
  /// The index (in [children]) of the branch Navigator to display.
  final int currentIndex;

  /// The children (branch Navigators) to display in this container.
  final List<Widget> children;

  /// Creates a AnimatedBranchContainer
  const AnimatedBranchContainer({
    super.key,
    required this.currentIndex,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: children.mapIndexed(
      (index, navigator) {
        return AnimatedScale(
          scale: index == currentIndex ? 1 : 1.5,
          duration: const Duration(milliseconds: 400),
          child: AnimatedOpacity(
            opacity: index == currentIndex ? 1 : 0,
            duration: const Duration(milliseconds: 400),
            child: _branchNavigatorWrapper(index, navigator),
          ),
        );
      },
    ).toList());
  }

  Widget _branchNavigatorWrapper(int index, Widget navigator) => IgnorePointer(
        ignoring: index != currentIndex,
        child: TickerMode(
          enabled: index == currentIndex,
          child: navigator,
        ),
      );
}
