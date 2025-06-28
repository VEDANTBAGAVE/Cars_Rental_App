import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_scaffold.dart'; // <-- Import your MainScaffold

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Simulate loading for 3 seconds, then navigate to MainScaffold
    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainScaffold()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2C30),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'VAN',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD69C39),
                      fontWeight: FontWeight.bold,
                      fontSize: 32,
                      letterSpacing: 1.5,
                    ),
                  ),
                  TextSpan(
                    text: 'TURE',
                    style: GoogleFonts.poppins(
                      color: const Color(0xFFD69C39),
                      fontWeight: FontWeight.normal,
                      fontSize: 32,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 180),
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 6.3,
                  child: child,
                );
              },
              child: SizedBox(
                width: 54,
                height: 54,
                child: CircularProgressIndicator(
                  strokeWidth: 6,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFD69C39),
                  ),
                  backgroundColor: const Color(0xFF212227),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
