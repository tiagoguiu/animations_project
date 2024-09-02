import 'dart:math';

import 'package:flutter/material.dart';

class PartSix extends StatefulWidget {
  const PartSix({super.key});

  @override
  State<PartSix> createState() => _PartSixState();
}

class _PartSixState extends State<PartSix> {
  late final Size screenSize = MediaQuery.sizeOf(context);

  Color color = getRandomColor();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ClipPath(
          clipper: const CircleClipper(),
          child: TweenAnimationBuilder(
            tween: ColorTween(begin: getRandomColor(), end: color),
            duration: const Duration(milliseconds: 400),
            onEnd: () => setState(() {
              color = getRandomColor();
            }),
            builder: (context, value, child) => Container(
              color: value,
              width: screenSize.width,
              height: screenSize.height,
            ),
          ),
        ),
      ),
    );
  }
}

class CircleClipper extends CustomClipper<Path> {
  const CircleClipper();
  @override
  Path getClip(Size size) {
    final path = Path();
    final rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: size.width / 2,
    );
    path.addOval(rect);
    return path;
  }

  @override //ONLY SHOULD USED WHEN SIZE CHANGES
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

Color getRandomColor() => Color(0xFF000000 + Random().nextInt(0x00FFFFFF));
