import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sammsel/core/constants/app_constants.dart';
import 'package:sammsel/auth/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Setup a simple animation (2 seconds)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    // Start the animation immediately
    _controller.forward();

    // 2. Start the navigation timer (Non-blocking)
    _startNavigationTimer();
  }

  void _startNavigationTimer() async {
    // Wait for 3 seconds to let the animation play and assets load
    await Future.delayed(const Duration(seconds: 3));

    // Check if the widget is still on screen before navigating
    if (mounted) {
      // Navigate to Login Screen
      // NOTE: If you are using GoRouter, use context.go('/login') instead.
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use a simple Gradient Background consistent with your app
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.primaryBackgroundColorDark, // Dark Blue/Black
              AppConstants.secondaryBackgroundColorDark, // Slightly lighter
            ],
          ),
        ),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo / Icon
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: AppConstants.accentColorLight.withValues(alpha: 0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded, // Example generic icon for "Publication"
                      size: 60,
                      color: AppConstants.accentColorLight,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // App Name
                  const Text(
                    'SAMSEL',
                    style: TextStyle(
                      fontFamily: 'Brush Script MT', // Using the font from your pubspec
                      fontSize: 48,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Publication Management',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}