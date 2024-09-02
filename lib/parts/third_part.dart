import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' show Vector3;

class ThirdHomePage extends StatefulWidget {
  const ThirdHomePage({super.key});

  @override
  State<ThirdHomePage> createState() => _ThirdHomePageState();
}

//TICKER PROVIDER STATE MIXIN CAN SYNC WITH MORE THAN ONE ANIMATION CONTROLLER
class _ThirdHomePageState extends State<ThirdHomePage> with TickerProviderStateMixin {
  late AnimationController xController;
  late AnimationController yController;
  late AnimationController zController;

  late Tween<double> animation;

  @override
  void initState() {
    super.initState();
    xController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    );
    yController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    zController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 40),
    );
    animation = Tween<double>(begin: 0.0, end: 2 * pi);
  }

  @override
  void dispose() {
    xController.dispose();
    yController.dispose();
    zController.dispose();
    super.dispose();
  }

  static const double widthAndHeight = 100;

  @override
  Widget build(BuildContext context) {
    xController
      ..reset()
      ..repeat();
    yController
      ..reset()
      ..repeat();
    zController
      ..reset()
      ..repeat();
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: widthAndHeight,
              width: double.infinity,
            ),
            AnimatedBuilder(
              animation: Listenable.merge(
                [
                  xController,
                  yController,
                  zController,
                ],
              ),
              builder: (context, child) => Transform(
                alignment: Alignment.center,
                transform: Matrix4.identity()
                  ..rotateX(animation.evaluate(xController))
                  ..rotateY(animation.evaluate(yController))
                  ..rotateZ(animation.evaluate(zController)),
                child: Stack(
                  children: [
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..translate(Vector3(0, 0, -widthAndHeight)),
                      child: Container(
                        color: Colors.green,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),
                    //LEFT SIDE
                    Transform(
                      alignment: Alignment.centerLeft,
                      transform: Matrix4.identity()..rotateY(pi / 2),
                      child: Container(
                        color: Colors.orange,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),
                    //RIGHT SIDE
                    Transform(
                      alignment: Alignment.centerRight,
                      transform: Matrix4.identity()..rotateY(-pi / 2),
                      child: Container(
                        color: Colors.blue,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),
                    //FRONT SIDE
                    Container(
                      color: Colors.red,
                      width: widthAndHeight,
                      height: widthAndHeight,
                    ),
                    //TOP SIDE
                    Transform(
                      alignment: Alignment.topCenter,
                      transform: Matrix4.identity()..rotateX(-pi / 2),
                      child: Container(
                        color: Colors.black,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),
                    //BOTTOM SIDE
                    Transform(
                      alignment: Alignment.bottomCenter,
                      transform: Matrix4.identity()..rotateX(pi / 2),
                      child: Container(
                        color: Colors.brown,
                        width: widthAndHeight,
                        height: widthAndHeight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
