import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_logo.dart';
import '../../provider/auth_provider.dart';
import '../login/login_screen.dart';
import '../home/home_screen.dart';
import '../../agent_screen/screens/agent_main_screen.dart';
import '../../helpers/shared_prefs_helper.dart';

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

    // Check login status and navigate after 3.5 seconds
    Timer(const Duration(milliseconds: 3500), () async {
      if (!mounted) return;
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isLoggedIn = await authProvider.checkLoginStatus();
      String? role;
      if (isLoggedIn) {
        role = await SharedPrefsHelper.getUserRole();
      }
      if (!mounted) return;

      Widget destination = const LoginScreen();
      if (isLoggedIn) {
        if (role == 'agent' || role == 'Agent') {
          destination = const AgentMainScreen();
        } else {
          destination = const HomeScreen();
        }
      }

      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => destination,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
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
                      children: const [
                        // Janta Trader Brand Logo (includes wordmark)
                        CustomLogo(size: 180.0),
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
