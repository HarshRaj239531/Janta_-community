import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';
import '../widgets/custom_logo.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _logoOpacity = 0.0;
  double _logoTranslate = 30.0;

  @override
  void initState() {
    super.initState();

    // Trigger animations after a tiny delay
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _logoOpacity = 1.0;
          _logoTranslate = 0.0;
        });
      }
    });

    // Navigate to HomeScreen after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const LoginScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // 1. 3D Coins Background Illustration
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenSize.height * 0.7,
            child: Image.asset(
              'assets/images/coins_splash_bg.png',
              fit: BoxFit.cover,
            ),
          ),

          // 2. Gradient overlay to blend the image background with the bottom white background
          Positioned(
            top: screenSize.height * 0.45,
            left: 0,
            right: 0,
            height: screenSize.height * 0.25,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Colors.white70,
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // 3. Branding Section (Logo + Name) at the bottom
          Positioned(
            bottom: screenSize.height * 0.08,
            left: 0,
            right: 0,
            child: TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOutBack,
              tween: Tween<double>(begin: _logoTranslate, end: _logoTranslate),
              builder: (context, translateValue, child) {
                return Transform.translate(
                  offset: Offset(0, translateValue),
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 800),
                    opacity: _logoOpacity,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Custom metallic gold PF logo
                        const CustomLogo(size: 110.0),
                        const SizedBox(height: 12),
                        // Golden text name "ProsperFin"
                        ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: AppColors.goldGradient,
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ).createShader(bounds),
                          child: Text(
                            'ProsperFin',
                            style: GoogleFonts.outfit(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // Required for shader to display
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
