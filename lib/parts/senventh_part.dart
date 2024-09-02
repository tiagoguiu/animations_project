// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:math';

import 'package:flutter/material.dart';

class SeventhHomePage extends StatefulWidget {
  const SeventhHomePage({super.key});

  @override
  State<SeventhHomePage> createState() => _SeventhHomePageState();
}

//TICKER PROVIDER STATE MIXIN CAN SYNC WITH MORE THAN ONE ANIMATION CONTROLLER
class _SeventhHomePageState extends State<SeventhHomePage> with TickerProviderStateMixin {
  late AnimationController sidesController;
  late Animation<int> sidesAnimation;

  late AnimationController radiusController;
  late Animation<double> radiusAnimation;

  late AnimationController rotationController;
  late Animation<double> rotationAnimation;
  @override
  void initState() {
    super.initState();
    sidesController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    sidesAnimation = IntTween(begin: 3, end: 10).animate(sidesController);

    radiusController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    radiusAnimation = Tween(begin: 20.0, end: 400.0)
        .chain(
          CurveTween(curve: Curves.bounceInOut),
        )
        .animate(radiusController);

    rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );
    rotationAnimation = Tween(begin: 0.0, end: 2 * pi)
        .chain(
          CurveTween(curve: Curves.easeInOut),
        )
        .animate(rotationController);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    sidesController.repeat(reverse: true);
    radiusController.repeat(reverse: true);
    rotationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    sidesController.dispose();
    radiusController.dispose();
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedBuilder(
          animation: Listenable.merge(
            [
              sidesController,
              radiusController,
              rotationController,
            ],
          ),
          builder: (context, child) => Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..rotateX(rotationAnimation.value)
              ..rotateY(rotationAnimation.value)
              ..rotateZ(rotationAnimation.value),
            child: CustomPaint(
              painter: Polygon(sides: sidesAnimation.value),
              child: SizedBox(
                width: radiusAnimation.value,
                height: radiusAnimation.value,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class Polygon extends CustomPainter {
  int sides;
  Polygon({
    required this.sides,
  });
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3;

    final Path path = Path();

    final Offset center = Offset(size.width / 2, size.height / 2);
    final double angle = (2 * pi) / sides;

    final List<double> angles = List.generate(sides, (index) => index * angle);

    final double radius = size.width / 2;

    path.moveTo(center.dx + radius * cos(0), center.dy + radius * sin(0)); //SETTING UP THE STARTING POINT OF CANVAS

    for (final angle in angles) {
      path.lineTo(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
    }

    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => oldDelegate is Polygon && oldDelegate.sides != sides;
}
