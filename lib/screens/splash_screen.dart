import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  bool isVisible = false;

  late AnimationController logoController;
  late Animation<double> fadeAnim;
  late Animation<double> scaleAnim;
  late Animation<Offset> slideAnim;

  @override
  void initState() {
    super.initState();

    logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    fadeAnim = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: logoController, curve: Curves.easeOut));

    scaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.75,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.0,
          end: 1.15,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 1.15,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 30,
      ),
    ]).animate(logoController);

    slideAnim = Tween(
      begin: const Offset(0, -0.25),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: logoController, curve: Curves.easeOut));

    Timer(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() => isVisible = true);
        logoController.forward();
      }
    });

    _checkAuthAndNavigate();
  }

  Future<void> _checkAuthAndNavigate() async {
    // Wait for animations to complete + a little bit of buffer
    await Future.delayed(const Duration(seconds: 3));

    final authService = Get.find<AuthService>();
    // Reload user to ensure we have fresh status
    await authService.reloadUser();

    if (authService.currentUser.value != null) {
      Get.offAllNamed('/home');
    } else {
      Get.offAllNamed('/login');
    }
  }

  @override
  void dispose() {
    logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFE8F5F7), Color(0xFFD4EEF2), Color(0xFFC0E7ED)],
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: isVisible ? 1 : 0,
            duration: const Duration(milliseconds: 1000),
            child: AnimatedScale(
              scale: isVisible ? 1 : 0.75,
              duration: const Duration(milliseconds: 1000),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// LOGO
                  SlideTransition(
                    position: slideAnim,
                    child: FadeTransition(
                      opacity: fadeAnim,
                      child: ScaleTransition(
                        scale: scaleAnim,
                        child: SizedBox(
                          width: 280,
                          child: Image.asset(
                            'assets/logo1.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 48),

                  /// LOADING DOTS
                  const _LoadingDots(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingDots extends StatefulWidget {
  const _LoadingDots();

  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget dot(int index) {
    return AnimatedBuilder(
      animation: controller,
      builder: (_, __) {
        final t = (controller.value + index * 0.2) % 1;
        final scale = t < 0.5 ? t * 2 : (1 - t) * 2;

        return Transform.scale(
          scale: 0.6 + scale * 0.4,
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFF1A7A8A),
              shape: BoxShape.circle,
            ),
            child: SizedBox(width: 10, height: 10),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        dot(0),
        const SizedBox(width: 6),
        dot(1),
        const SizedBox(width: 6),
        dot(2),
      ],
    );
  }
}
