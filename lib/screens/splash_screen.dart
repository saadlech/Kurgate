import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _logoController;
  late AnimationController _shimmerController;
  late AnimationController _exitController;

  late Animation<double> _iconScale;
  late Animation<double> _iconRotation;
  late Animation<double> _iconOpacity;
  late Animation<double> _logoOpacity;
  late Animation<Offset> _logoSlide;
  late Animation<double> _shimmerPosition;
  late Animation<double> _exitFade;

  @override
  void initState() {
    super.initState();

    // Phase 1: Icon enters — scale up + rotate + fade in (0–800ms)
    _iconController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.elasticOut,
      ),
    );

    _iconRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: Curves.easeOutBack,
      ),
    );

    _iconOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Phase 2: Full logo text fades in + slides (800–1400ms)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeInOut,
      ),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Phase 3: Shimmer sweep across logo (1400–2000ms)
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _shimmerPosition = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(
        parent: _shimmerController,
        curve: Curves.easeInOut,
      ),
    );

    // Phase 4: Exit fade (2400–3000ms)
    _exitController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _exitFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _exitController,
        curve: Curves.easeInOut,
      ),
    );

    _startAnimation();
  }

  Future<void> _startAnimation() async {
    // Phase 1: Icon enters
    await Future.delayed(const Duration(milliseconds: 200));
    _iconController.forward();

    // Phase 2: Logo text appears
    await Future.delayed(const Duration(milliseconds: 800));
    _logoController.forward();

    // Phase 3: Shimmer sweep
    await Future.delayed(const Duration(milliseconds: 700));
    _shimmerController.forward();

    // Hold for a moment
    await Future.delayed(const Duration(milliseconds: 800));

    // Phase 4: Exit
    _exitController.forward();
    await Future.delayed(const Duration(milliseconds: 600));

    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _iconController.dispose();
    _logoController.dispose();
    _shimmerController.dispose();
    _exitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _iconController,
          _logoController,
          _shimmerController,
          _exitController,
        ]),
        builder: (context, child) {
          return FadeTransition(
            opacity: _exitFade,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated icon
                  FadeTransition(
                    opacity: _iconOpacity,
                    child: Transform.scale(
                      scale: _iconScale.value,
                      child: Transform.rotate(
                        angle: _iconRotation.value,
                        child: Image.asset(
                          'assets/images/icon_orange.png',
                          height: 100,
                          width: 100,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Logo text with shimmer
                  SlideTransition(
                    position: _logoSlide,
                    child: FadeTransition(
                      opacity: _logoOpacity,
                      child: ShaderMask(
                        shaderCallback: (bounds) {
                          return LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: const [
                              Colors.white,
                              Color(0xFFFF8C00),
                              Colors.white,
                            ],
                            stops: [
                              (_shimmerPosition.value - 0.3).clamp(0.0, 1.0),
                              _shimmerPosition.value.clamp(0.0, 1.0),
                              (_shimmerPosition.value + 0.3).clamp(0.0, 1.0),
                            ],
                          ).createShader(bounds);
                        },
                        blendMode: BlendMode.srcIn,
                        child: const Text(
                          'kurgate.',
                          style: TextStyle(
                            fontFamily: 'DarkerGrotesque',
                            fontSize: 52,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Tagline
                  FadeTransition(
                    opacity: _logoOpacity,
                    child: Text(
                      'Explore Morocco, your way.',
                      style: TextStyle(
                        fontFamily: 'DarkerGrotesque',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withValues(alpha: 0.5),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
