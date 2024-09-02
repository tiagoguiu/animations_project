import 'dart:math';

import 'package:flutter/material.dart';

class SecondHomePage extends StatefulWidget {
  const SecondHomePage({super.key});

  @override
  State<SecondHomePage> createState() => _SecondHomePageState();
}

//TICKER PROVIDER STATE MIXIN CAN SYNC WITH MORE THAN ONE ANIMATION CONTROLLER
class _SecondHomePageState extends State<SecondHomePage> with TickerProviderStateMixin {
  late AnimationController counterClockWiseController;
  late Animation<double> counterClockWiseAnimation;

  late AnimationController flipController;
  late Animation<double> flipAnimation;
  @override
  void initState() {
    super.initState();
    //FISRT PART ROTATING FROM RIGHT TO LEFT 180° IN Z PLANE
    counterClockWiseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    counterClockWiseAnimation = Tween(begin: 0.0, end: -(pi / 2)).animate(
      CurvedAnimation(
        parent: counterClockWiseController,
        curve: Curves.bounceOut,
      ),
    );

    //FISRT PART FLIPING FROM RIGHT TO LEFT 180° IN Y PLANE
    flipController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
    flipAnimation = Tween(begin: 0.0, end: pi).animate(
      CurvedAnimation(
        parent: flipController,
        curve: Curves.bounceOut,
      ),
    );

    counterClockWiseController.addStatusListener(handleAnimationStatus);
    flipController.addStatusListener(handleFlipAnimationStatus);
  }

  void handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      flipAnimation = Tween(
        begin: flipAnimation.value,
        end: flipAnimation.value + pi,
      ).animate(
        CurvedAnimation(
          parent: flipController,
          curve: Curves.bounceOut,
        ),
      );

      flipController
        ..reset()
        ..forward();
    }
  }

  void handleFlipAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      counterClockWiseAnimation = Tween(
        begin: counterClockWiseAnimation.value,
        end: counterClockWiseAnimation.value + -(pi / 2),
      ).animate(
        CurvedAnimation(
          parent: counterClockWiseController,
          curve: Curves.bounceOut,
        ),
      );
      counterClockWiseController
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    counterClockWiseController.dispose();
    flipController.dispose();
    counterClockWiseController.removeStatusListener(handleAnimationStatus);
    flipController.removeStatusListener(handleFlipAnimationStatus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(
      const Duration(seconds: 1),
      () => counterClockWiseController
        ..reset()
        ..forward(),
    );
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: counterClockWiseController,
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()..rotateZ(counterClockWiseAnimation.value),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: flipController,
                  builder: (context, child) => Transform(
                    alignment: Alignment.centerRight,
                    transform: Matrix4.identity()..rotateY(flipAnimation.value),
                    child: ClipPath(
                      clipper: HalfCircleClipper(side: CircleSide.left),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.blue),
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
                AnimatedBuilder(
                  animation: flipController,
                  builder: (context, child) => Transform(
                    alignment: Alignment.centerLeft,
                    transform: Matrix4.identity()..rotateY(flipAnimation.value),
                    child: ClipPath(
                      clipper: HalfCircleClipper(side: CircleSide.right),
                      child: Container(
                        decoration: const BoxDecoration(color: Colors.yellow),
                        width: 100,
                        height: 100,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum CircleSide { left, right }

extension ToPath on CircleSide {
  Path toPath(Size size) {
    final path = Path();
    late Offset offSet;
    late bool clockWise;

    switch (this) {
      case CircleSide.left:
        path.moveTo(size.width, 0);
        offSet = Offset(size.width, size.height);
        clockWise = false;
        break;
      case CircleSide.right:
        offSet = Offset(0, size.height);
        clockWise = true;
        break;
    }
    path.arcToPoint(
      offSet,
      radius: Radius.elliptical(size.width / 2, size.height / 2),
      clockwise: clockWise,
    );
    path.close();
    return path;
  }
}

final class HalfCircleClipper extends CustomClipper<Path> {
  final CircleSide side;

  HalfCircleClipper({required this.side});
  @override
  getClip(Size size) => side.toPath(size);

  @override
  bool shouldReclip(covariant CustomClipper oldClipper) => true;
}
