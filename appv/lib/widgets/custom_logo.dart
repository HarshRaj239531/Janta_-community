import 'package:flutter/material.dart';

class CustomLogo extends StatelessWidget {
  final double size;

  const CustomLogo({
    super.key,
    this.size = 100.0,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/images/janta_trader_logo.jpg',
      width: size,
      height: size,
      fit: BoxFit.contain,
    );
  }
}
