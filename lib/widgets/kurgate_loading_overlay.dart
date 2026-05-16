import 'package:flutter/material.dart';

/// A fullscreen loading overlay that shows the Kurgate logo rotating.
/// On success, the logo flies up and disappears.
class KurgateLoadingOverlay extends StatefulWidget {
  final bool isLoading;
  final bool success;
  final VoidCallback? onFlyAwayComplete;

  const KurgateLoadingOverlay({
    super.key,
    required this.isLoading,
    this.success = false,
    this.onFlyAwayComplete,
  });

  @override
  State<KurgateLoadingOverlay> createState() => _KurgateLoadingOverlayState();
}

class _KurgateLoadingOverlayState extends State<KurgateLoadingOverlay>
    with TickerProviderStateMixin {
  late AnimationController _spinController;
  late AnimationController _flyController;
  late AnimationController _fadeController;

  late Animation<double> _flyPosition;
  late Animation<double> _flyScale;
  late Animation<double> _flyOpacity;
  late Animation<double> _bgFade;

  bool _visible = false;
  bool _flyingAway = false;

  @override
  void initState() {
    super.initState();

    // Continuous spin
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Fly away animation
    _flyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _flyPosition = Tween<double>(begin: 0.0, end: -400.0).animate(
      CurvedAnimation(parent: _flyController, curve: Curves.easeInBack),
    );

    _flyScale = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _flyController, curve: Curves.easeIn),
    );

    _flyOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _flyController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeIn),
      ),
    );

    // Background fade in/out
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _bgFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );

    if (widget.isLoading) {
      _show();
    }
  }

  @override
  void didUpdateWidget(covariant KurgateLoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !oldWidget.isLoading) {
      _show();
    }

    if (widget.success && !oldWidget.success && _visible) {
      _flyAway();
    }

    if (!widget.isLoading && !widget.success && oldWidget.isLoading) {
      _hide();
    }
  }

  void _show() {
    setState(() => _visible = true);
    _flyingAway = false;
    _flyController.reset();
    _fadeController.forward();
    _spinController.repeat();
  }

  void _hide() {
    _fadeController.reverse().then((_) {
      if (mounted) {
        _spinController.stop();
        setState(() => _visible = false);
      }
    });
  }

  void _flyAway() {
    _flyingAway = true;
    _spinController.stop();
    _flyController.forward().then((_) {
      if (mounted) {
        _fadeController.reverse().then((_) {
          if (mounted) {
            setState(() {
              _visible = false;
              _flyingAway = false;
            });
            widget.onFlyAwayComplete?.call();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _spinController.dispose();
    _flyController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: Listenable.merge([_spinController, _flyController, _fadeController]),
      builder: (context, _) {
        return IgnorePointer(
          ignoring: false,
          child: Opacity(
            opacity: _bgFade.value,
            child: Container(
              color: const Color(0xFF1A1A1A).withValues(alpha: 0.85),
              child: Center(
                child: Transform.translate(
                  offset: Offset(0, _flyingAway ? _flyPosition.value : 0),
                  child: Transform.scale(
                    scale: _flyingAway ? _flyScale.value : 1.0,
                    child: Opacity(
                      opacity: _flyingAway ? _flyOpacity.value : 1.0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Spinning logo with glow
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFFFF8C00)
                                      .withValues(alpha: 0.3),
                                  blurRadius: 40,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: RotationTransition(
                              turns: _spinController,
                              child: Image.asset(
                                'assets/images/branding/icon_orange.png',
                                height: 80,
                                width: 80,
                              ),
                            ),
                          ),

                          const SizedBox(height: 28),

                          // Loading text with shimmer dots
                          if (!_flyingAway)
                            _LoadingDots(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Animated "..." dots
class _LoadingDots extends StatefulWidget {
  @override
  State<_LoadingDots> createState() => _LoadingDotsState();
}

class _LoadingDotsState extends State<_LoadingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final delay = i * 0.2;
            final progress = (_controller.value - delay).clamp(0.0, 1.0);
            final opacity = (0.3 + 0.7 * (0.5 + 0.5 * 
              _sin(progress * 3.14159 * 2))).clamp(0.3, 1.0);
            final yOffset = -4.0 * _sin(progress * 3.14159 * 2).clamp(0.0, 1.0);

            return Transform.translate(
              offset: Offset(0, yOffset),
              child: Opacity(
                opacity: opacity,
                child: Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFFF8C00),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }

  double _sin(double x) {
    // Simple approximation for smooth animation
    x = x % (3.14159 * 2);
    if (x < 3.14159) {
      return 4 * x * (3.14159 - x) / (3.14159 * 3.14159);
    } else {
      x = x - 3.14159;
      return -4 * x * (3.14159 - x) / (3.14159 * 3.14159);
    }
  }
}
