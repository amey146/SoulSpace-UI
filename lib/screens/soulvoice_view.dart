import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class SoulVoiceView extends StatefulWidget {
  const SoulVoiceView({super.key});

  @override
  SoulVoiceViewState createState() => SoulVoiceViewState();
}

class SoulVoiceViewState extends State<SoulVoiceView>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;
  StateMachineController? _riveController;
  SMIInput<bool>? _noInternetInput;
  SMIInput<bool>? _errorInput;

  bool _isNoInternet = false;
  bool _isError = false;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  // Initialize Rive Controller
  void _onRiveInit(Artboard artboard) {
    final controller = StateMachineController.fromArtboard(
      artboard,
      'State Machine',
    );
    if (controller != null) {
      artboard.addController(controller);
      _riveController = controller;

      // Bind Rive inputs to Flutter controls
      _noInternetInput = controller.findInput<bool>('No Internet');
      _errorInput = controller.findInput<bool>('Error');

      if (_noInternetInput == null || _errorInput == null) {
        print("Error: Rive inputs not found.");
      } else {
        print("Rive inputs initialized successfully.");
      }
    } else {
      print("Error: State Machine Controller not found.");
    }
  }

  // Update animation based on the checkboxes
  void _updateAnimation() {
    if (_noInternetInput != null && _errorInput != null) {
      _noInternetInput?.value = _isNoInternet;
      _errorInput?.value = _isError;

      print(
          "No Internet: ${_noInternetInput?.value}, Error: ${_errorInput?.value}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Robot Image
          Container(
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
                SizedBox(
                  height: 450,
                  child: RiveAnimation.asset(
                    "assets/robocat.riv",
                    fit: BoxFit.fitHeight,
                    stateMachines: ['State Machine'],
                    artboard: 'Catbot',
                    onInit: _onRiveInit, // Initialize the Rive animation
                  ),
                ),
                SizedBox(
                  height: 100,
                  width: double.infinity,
                  child: AnimatedBuilder(
                    animation: _waveController,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: WavePainter(_waveController.value),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Checkbox for "No Internet"
                    Checkbox(
                      value: _isNoInternet,
                      onChanged: (bool? value) {
                        setState(() {
                          _isNoInternet = value ?? false;
                          _isError = !_isNoInternet && _isError;
                          _updateAnimation();
                        });
                      },
                    ),
                    const Text("No Internet",
                        style: TextStyle(color: Colors.white)),

                    const SizedBox(width: 20),

                    // Checkbox for "Error"
                    Checkbox(
                      value: _isError,
                      onChanged: (bool? value) {
                        setState(() {
                          _isError = value ?? false;
                          _isNoInternet = !_isError && _isNoInternet;
                          _updateAnimation();
                        });
                      },
                    ),
                    const Text("Error", style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
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
