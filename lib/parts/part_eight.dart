import 'dart:math';

import 'package:flutter/material.dart';

class PartEight extends StatefulWidget {
  const PartEight({super.key});

  @override
  State<PartEight> createState() => _PartEightState();
}

class _PartEightState extends State<PartEight> {
  late final Size screenSize = MediaQuery.sizeOf(context);

  @override
  Widget build(BuildContext context) {
    return CustomDrawer(
      drawer: Material(
        color: const Color(0xff24283b),
        child: SizedBox(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 80, top: 100),
            itemCount: 20,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                'item $index',
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Drawer Test'),
        ),
        body: Container(
          color: const Color(0xff414868),
        ),
      ),
    );
  }
}

class CustomDrawer extends StatefulWidget {
  final Widget child;
  final Widget drawer;

  const CustomDrawer({
    super.key,
    required this.child,
    required this.drawer,
  });

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> with TickerProviderStateMixin {
  late final Size screenSize = MediaQuery.sizeOf(context);
  late final maxDrag = screenSize.width * 0.8;

  late AnimationController xControllerForChild;
  late Animation<double> yRotationAnimationForChild;

  late AnimationController xControllerForDrawer;
  late Animation<double> yRotationAnimationForDrawer;

  @override
  void initState() {
    super.initState();
    xControllerForChild = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    yRotationAnimationForChild = Tween<double>(
      begin: 0.0,
      end: -pi / 2,
    ).animate(xControllerForChild);

    xControllerForDrawer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    yRotationAnimationForDrawer = Tween<double>(
      begin: -pi / 2.7,
      end: 0.0,
    ).animate(xControllerForDrawer);
  }

  @override
  void dispose() {
    xControllerForChild.dispose();
    xControllerForDrawer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        final double delta = details.delta.dx / maxDrag;
        xControllerForChild.value += delta;
        xControllerForDrawer.value += delta;
      },
      onHorizontalDragEnd: (details) {
        if (xControllerForChild.value < 0.5) {
          xControllerForChild.reverse();
          xControllerForDrawer.reverse();
        } else {
          xControllerForChild.forward();
          xControllerForDrawer.forward();
        }
      },
      child: AnimatedBuilder(
          animation: Listenable.merge([
            xControllerForChild,
            xControllerForDrawer,
          ]),
          builder: (context, child) {
            return Stack(
              children: [
                Container(
                  color: const Color(0xFF1a1b26),
                ),
                Transform(
                  alignment: Alignment.centerLeft,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001) //PERSPECTIVE
                    ..translate(
                      xControllerForChild.value * maxDrag,
                    )
                    ..rotateY(
                      yRotationAnimationForChild.value,
                    ),
                  child: widget.child,
                ),
                Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..translate(
                      -screenSize.width + xControllerForDrawer.value * maxDrag,
                    )
                    ..rotateY(
                      yRotationAnimationForDrawer.value,
                    ),
                  child: widget.drawer,
                ),
              ],
            );
          }),
    );
  }
}
