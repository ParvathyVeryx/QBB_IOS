import 'package:QBB/screens/pages/welcome.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Future.delayed to introduce a delay
    Future.delayed(const Duration(seconds: 5), () {
      // Navigate to the Welcome screen after the delay
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Welcome()),
      );
    });

    return Scaffold(
      body: Center(
        child: Image.asset(
          'assets/images/splash.gif',
          height: 600.0,
          width: 600.0,
        ),
      ),
    );
  }
}
