import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final Widget? front;
  final Widget? back;
  const FlipCard({
    Key? key,
    @required this.front,
    @required this.back,
  })  : assert(front != null),
        assert(back != null),
        super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with TickerProviderStateMixin {
  final ValueNotifier<double> angle;
  late AnimationController animationController;
  late Animation<double> frontAnimation;
  late Animation<double> backAnimation;

  _FlipCardState() : angle = ValueNotifier(0.0);

  bool isFront = true;
  bool hasHalf = false;
  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1000),
    );
    animationController.addListener(() {
      if (animationController.value > 0.5) {
        if (hasHalf == false) {
          isFront = !isFront;
        }
        hasHalf = true;
      }
      setState(() {});
    });
    animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        hasHalf = false;
      }
    });
    frontAnimation = Tween(begin: 0.0, end: 0.5).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );
    backAnimation = Tween(begin: 1.5, end: 2.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeOut)));
  }

  void animate() {
    animationController.stop();
    animationController.value = 0;
    animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (animationController.status == AnimationStatus.forward) {
      if (hasHalf == true) {
        angle.value = backAnimation.value;
      } else {
        angle.value = frontAnimation.value;
      }
    }
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        print(details.delta);
        angle.value += 0.01;
      },
      child: Container(
        child: ValueListenableBuilder(
          valueListenable: angle,
          builder: (BuildContext context, double angle, Widget? child) {
            return Transform(
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(angle),
              alignment: Alignment.center,
              child: IndexedStack(
                index: isFront ? 0 : 1,
                children: <Widget>[widget.front!, widget.back!],
              ),
            );
          },
        ),
      ),
    );
  }
}
