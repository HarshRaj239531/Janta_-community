import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Very subtle glowing colors with extremely low opacity so they are barely visible
    final primaryGlow = AppColors.primaryGreen.withAlpha(12); // ~5% opacity
    final secondaryGlow = AppColors.accentMint.withAlpha(15); // ~6% opacity

    return Stack(
      children: [
        // Solid layout scaffold background base
        Positioned.fill(
          child: Container(
            color: const Color(0xFFF3F5F8), // Matches scaffold background
          ),
        ),

        // Glowing Animated Circle 1
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double angle = _controller.value * 2 * math.pi;
            final double dx = 50 * math.sin(angle);
            final double dy = 40 * math.cos(angle);
            return Positioned(
              top: 80 + dy,
              left: -60 + dx,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryGlow,
                ),
              ),
            );
          },
        ),

        // Glowing Animated Circle 2
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final double angle = _controller.value * 2 * math.pi + 2.0;
            final double dx = 40 * math.cos(angle);
            final double dy = 60 * math.sin(angle);
            return Positioned(
              bottom: 120 + dy,
              right: -70 + dx,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: secondaryGlow,
                ),
              ),
            );
          },
        ),

        // Glassmorphic blur overlay to make the circles super soft and faint
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 60.0, sigmaY: 60.0),
            child: const SizedBox(),
          ),
        ),

        // The actual child screen content
        Positioned.fill(
          child: widget.child,
        ),
      ],
    );
  }
}
