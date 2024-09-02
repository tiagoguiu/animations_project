import 'package:flutter/material.dart';

class PartFive extends StatefulWidget {
  const PartFive({super.key});

  @override
  State<PartFive> createState() => _PartFiveState();
}

class _PartFiveState extends State<PartFive> {
  bool isZoomedIn = false;

  double defaultWidth = 100;
  static const double localWidth = 100;
  Curve curve = Curves.bounceOut;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          AnimatedContainer(
            decoration: const FlutterLogoDecoration(),
            width: defaultWidth,
            curve: curve,
            duration: const Duration(milliseconds: 400),
          ),
          TextButton(
            onPressed: () => setState(() {
              isZoomedIn = !isZoomedIn;
              defaultWidth = isZoomedIn ? MediaQuery.sizeOf(context).width : localWidth;
              curve = isZoomedIn ? Curves.bounceInOut : Curves.bounceOut;
            }),
            child: Text(isZoomedIn ? 'Zoom out' : 'Zoom in'),
          ),
        ],
      ),
    );
  }
}
