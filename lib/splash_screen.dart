import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_scaffold.dart';
import 'screens/login_screen.dart';
import 'services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    // Check login status and navigate accordingly
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    // Wait for 3 seconds to show splash screen
    await Future.delayed(const Duration(seconds: 3));
    
    // Check if user is logged in
    bool isLoggedIn = await _authService.isLoggedIn();
    
    if (mounted) {
      if (isLoggedIn) {
        // User is logged in, go to main app
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainScaffold()),
        );
      } else {
        // User is not logged in, go to login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
        );
      }
    }
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
