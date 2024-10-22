import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(
      home: SplashScreen(),
    ));

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(body: Container()),
    );
  }
}
