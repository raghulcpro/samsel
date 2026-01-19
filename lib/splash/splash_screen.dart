import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _bubbleController;

  @override
  void initState() {
    super.initState();

    // 1. Main Fade/Scale Animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.forward();

    // 2. Continuous Floating Bubble Animation
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // 3. Navigation Timer
    _startNavigationTimer();
  }

  void _startNavigationTimer() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      // Use GoRouter context.go to allow main.dart redirect logic to work
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // --- COLORS MATCHING YOUR LOGIN SCREEN ---
    // The soft background pink from your login screen
    const Color bgPinkTop = Color(0xFFFDEFF6);
    // The vibrant button/logo pink
    const Color accentPink = Color(0xFFF52F78);
    const Color textDark = Color(0xFF555555);

    return Scaffold(
      body: Stack(
        children: [
          // LAYER 1: Light Gradient Background (Matches Login Screen)
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                // Soft Pink -> White -> Soft Pink
                colors: [bgPinkTop, Colors.white, bgPinkTop],
              ),
            ),
          ),

          // LAYER 2: Floating "Pink Glass" Bubbles
          // Modified to be visible on light background (Pink tint)
          Positioned(
            top: 100,
            left: 40,
            child: _AnimatedBubble(
                animation: _bubbleController,
                size: 60,
                delay: 0,
                color: accentPink
            ),
          ),
          Positioned(
            bottom: 150,
            right: 30,
            child: _AnimatedBubble(
                animation: _bubbleController,
                size: 80,
                delay: 1.5,
                color: accentPink
            ),
          ),
          Positioned(
            top: 200,
            right: 50,
            child: _AnimatedBubble(
                animation: _bubbleController,
                size: 40,
                delay: 2.5,
                color: accentPink
            ),
          ),
          Positioned(
            bottom: 80,
            left: 80,
            child: _AnimatedBubble(
                animation: _bubbleController,
                size: 50,
                delay: 0.5,
                color: accentPink
            ),
          ),

          // LAYER 3: Central Glowing Logo
          Center(
            child: FadeTransition(
              opacity: _controller,
              child: ScaleTransition(
                scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // The Glowing Ring Container
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        // Glassy Pink Fill
                        color: accentPink.withValues(alpha: 0.1),
                        border: Border.all(
                            color: accentPink.withValues(alpha: 0.3),
                            width: 1
                        ),
                        boxShadow: [
                          // Strong Pink Glow
                          BoxShadow(
                            color: accentPink.withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                          // Subtle Inner White Glow
                          BoxShadow(
                            color: Colors.white.withValues(alpha: 0.8),
                            blurRadius: 20,
                            spreadRadius: -5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Central Solid Circle (Like Login Logo)
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    accentPink,
                                    Color(0xFFFF5996) // Lighter pink for gradient
                                  ]
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: accentPink.withValues(alpha: 0.4),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                )
                              ],
                            ),
                            child: const Icon(
                              Icons.menu_book_rounded,
                              size: 50,
                              color: Colors.white,
                            ),
                          ),

                          // Glossy Reflection (Top Left)
                          Positioned(
                            top: 35,
                            left: 50,
                            child: Container(
                              width: 30,
                              height: 15,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // SAMSEL Text
                    // Using Dark Grey to match Login Screen text style
                    Text(
                      'SAMSEL',
                      style: TextStyle(
                        fontFamily: 'Brush Script MT',
                        fontSize: 42,
                        color: textDark.withValues(alpha: 0.8),
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Tagline
                    const Text(
                      'Publication Management System',
                      style: TextStyle(
                        fontSize: 14,
                        color: accentPink, // Pink tagline to tie it together
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Helper Widget for the "Pink Glass Bubbles"
class _AnimatedBubble extends StatelessWidget {
  final Animation<double> animation;
  final double size;
  final double delay;
  final Color color;

  const _AnimatedBubble({
    required this.animation,
    required this.size,
    required this.delay,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        // Floating Sine Wave Effect
        final double offset = math.sin((animation.value * 2 * math.pi) + delay) * 15;
        return Transform.translate(
          offset: Offset(0, offset),
          child: child,
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Pink-tinted Gradient for Glass Effect
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.15), // Very light pink
              color.withValues(alpha: 0.05), // Almost clear
            ],
          ),
          border: Border.all(
              color: color.withValues(alpha: 0.1),
              width: 1
          ),
        ),
        // Add a "shine" dot
        child: Stack(
          children: [
            Positioned(
              top: size * 0.2,
              left: size * 0.2,
              child: Container(
                width: size * 0.25,
                height: size * 0.25,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.5), // White reflection
                    boxShadow: const [
                      BoxShadow(color: Colors.white, blurRadius: 5)
                    ]
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}