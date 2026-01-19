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
    // --- BRAND COLORS ---
    const Color bgPinkTop = Color(0xFFFDEFF6);
    const Color brandPink = Color(0xFFD8276A); // Your requested color
    const Color accentPink = Color(0xFFF52F78);

    return Scaffold(
      body: Stack(
        children: [
          // LAYER 1: Light Gradient Background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [bgPinkTop, Colors.white, bgPinkTop],
              ),
            ),
          ),

          // LAYER 2: Floating Bubbles
          Positioned(
            top: 100,
            left: 40,
            child: _AnimatedBubble(
                animation: _bubbleController,
                size: 60,
                delay: 0,
                color: accentPink),
          ),
          Positioned(
            bottom: 150,
            right: 30,
            child: _AnimatedBubble(
                animation: _bubbleController,
                size: 80,
                delay: 1.5,
                color: accentPink),
          ),
          Positioned(
            top: 200,
            right: 50,
            child: _AnimatedBubble(
                animation: _bubbleController,
                size: 40,
                delay: 2.5,
                color: accentPink),
          ),

          // LAYER 3: Central Content
          Center(
            child: FadeTransition(
              opacity: _controller,
              child: ScaleTransition(
                scale: CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Glowing Ring Container
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentPink.withValues(alpha: 0.1),
                        border: Border.all(
                            color: accentPink.withValues(alpha: 0.3),
                            width: 1),
                        boxShadow: [
                          BoxShadow(
                            color: accentPink.withValues(alpha: 0.3),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Central Solid Circle
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [accentPink, Color(0xFFFF5996)]),
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
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),

                    Text(
                      'SAMSEL',
                      style: TextStyle(
                        fontFamily: 'Brush Script MT',
                        fontWeight: FontWeight.bold,
                        fontSize: 55,
                        color: brandPink,
                        letterSpacing: 1.2,
                        shadows: [
                          Shadow(
                            blurRadius: 10.0,
                            color: brandPink.withValues(alpha: 0.2),
                            offset: const Offset(0, 0),
                          ),
                        ],
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

// Helper Widget for Animated Bubbles
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
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.15),
              color.withValues(alpha: 0.05),
            ],
          ),
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
        ),
      ),
    );
  }
}