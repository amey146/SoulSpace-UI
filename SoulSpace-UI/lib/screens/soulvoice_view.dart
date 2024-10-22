import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SoulVoiceView extends StatefulWidget {
  const SoulVoiceView({super.key});

  @override
  SoulVoiceViewState createState() => SoulVoiceViewState();
}

class SoulVoiceViewState extends State<SoulVoiceView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Robot Image
          Container(
            // color: Color(0xff120025),
            color: Colors.black,
          ),
          // Centering the content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hi, I am Soul Voice",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                const SizedBox(
                    height: 8), // Small space between title and subtitle
                Text(
                  "Tell me how can I help you",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 30), // Space between robot and text
                // Robot animation
                const SizedBox(
                  height: 450,
                  child: RiveAnimation.asset(
                    "assets/robocat.riv",
                    fit: BoxFit.fitHeight,
                    stateMachines: ['State Machine'],
                    artboard: 'Catbot',
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WavePainter(_controller.value),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class GlassmorphismContainer extends StatelessWidget {
  final Widget child;

  const GlassmorphismContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      height: 400,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2), // Semi-transparent background
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          width: 2,
          color: Colors.white.withOpacity(0.2),
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Glass blur effect
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
            child: child,
          ),
        ),
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  final double animationValue;

  WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final Paint wavePaint1 = Paint()
      ..color = Colors.blue.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint wavePaint2 = Paint()
      ..color = Colors.pink.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final Paint wavePaint3 = Paint()
      ..color = Colors.purple.withOpacity(0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path1 = Path();
    final path2 = Path();
    final path3 = Path();

    // First wave
    for (double i = 0; i <= size.width; i++) {
      double waveHeight =
          sin((i / size.width * 2 * pi * 0.5) + animationValue * 2 * pi) * 30;
      if (i == 0) {
        path1.moveTo(i, size.height / 2 + waveHeight);
      } else {
        path1.lineTo(i, size.height / 2 + waveHeight);
      }
    }

    // Second wave
    for (double i = 0; i <= size.width; i++) {
      double waveHeight =
          sin((i / size.width * 2 * pi * 0.4) + animationValue * 2 * pi) * 25;
      if (i == 0) {
        path2.moveTo(i, size.height / 2 - 50 + waveHeight);
      } else {
        path2.lineTo(i, size.height / 2 - 50 + waveHeight);
      }
    }

    // Third wave
    for (double i = 0; i <= size.width; i++) {
      double waveHeight =
          sin((i / size.width * 2 * pi * 0.3) + animationValue * 2 * pi) * 20;
      if (i == 0) {
        path3.moveTo(i, size.height / 2 + 50 + waveHeight);
      } else {
        path3.lineTo(i, size.height / 2 + 50 + waveHeight);
      }
    }

    // Draw the wave paths
    canvas.drawPath(path1, wavePaint1);
    canvas.drawPath(path2, wavePaint2);
    canvas.drawPath(path3, wavePaint3);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
