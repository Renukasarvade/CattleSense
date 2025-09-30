import 'dart:async';
import 'package:flutter/material.dart';
import 'home_page.dart';

class SplashPulseLogo extends StatefulWidget {
  const SplashPulseLogo({super.key});

  @override
  State<SplashPulseLogo> createState() => _SplashPulseLogoState();
}

class _SplashPulseLogoState extends State<SplashPulseLogo>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    Timer(const Duration(seconds: 5), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage()),
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
      backgroundColor: Color(0xFFFFAEBF),
      body: Center(
        child: ScaleTransition(
          scale: _animation,
          child: Image.asset(
            'assets/assets/logo.png',
            width: 260,
            height: 260,
          ),
        ),
      ),
    );
  }
}

