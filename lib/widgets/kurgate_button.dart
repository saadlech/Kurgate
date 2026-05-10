import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A premium animated button with scale press effect, optional glow,
/// and a spinning Kurgate logo that flies to the right with smoke trail.
class KurgateButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isSuccess;
  final VoidCallback? onSuccessAnimComplete;
  final IconData? trailingIcon;
  final double height;
  final double? width;
  final double fontSize;
  final bool outlined;

  const KurgateButton({
    super.key,
    required this.label,
    this.onPressed,
    this.isLoading = false,
    this.isSuccess = false,
    this.onSuccessAnimComplete,
    this.trailingIcon,
    this.height = 56,
    this.width,
    this.fontSize = 18,
    this.outlined = false,
  });

  @override
  State<KurgateButton> createState() => _KurgateButtonState();
}

class _KurgateButtonState extends State<KurgateButton>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  late AnimationController _spinController;
  late AnimationController _flyController;

  bool _pressed = false;
  bool _showLogo = false;
  bool _flyingAway = false;

  @override
  void initState() {
    super.initState();

    // Glow pulse on button
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.2, end: 0.45).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    // Spinning logo
    _spinController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Fly-away animation (0→1 progress)
    _flyController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _flyController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (mounted) {
          setState(() {
            _showLogo = false;
            _flyingAway = false;
          });
          _spinController.stop();
          _flyController.reset();
          widget.onSuccessAnimComplete?.call();
        }
      }
    });

    if (widget.isLoading) _startLoading();
  }

  @override
  void didUpdateWidget(covariant KurgateButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isLoading && !oldWidget.isLoading) {
      _startLoading();
    }

    if (widget.isSuccess && !oldWidget.isSuccess && _showLogo) {
      _startFlyAway();
    }

    if (!widget.isLoading && !widget.isSuccess && oldWidget.isLoading && !_flyingAway) {
      _stopLoading();
    }
  }

  void _startLoading() {
    setState(() => _showLogo = true);
    _spinController.repeat();
  }

  void _stopLoading() {
    _spinController.stop();
    setState(() => _showLogo = false);
  }

  void _startFlyAway() {
    setState(() => _flyingAway = true);
    _spinController.stop();
    _flyController.forward();
  }

  @override
  void dispose() {
    _glowController.dispose();
    _spinController.dispose();
    _flyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.isLoading && !widget.isSuccess;

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: enabled
          ? (_) {
              setState(() => _pressed = false);
              widget.onPressed?.call();
            }
          : null,
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedBuilder(
        animation: _glowAnim,
        builder: (context, child) {
          return AnimatedScale(
            scale: _pressed ? 0.95 : 1.0,
            duration: const Duration(milliseconds: 120),
            curve: Curves.easeOut,
            child: AnimatedOpacity(
              opacity: _pressed ? 0.85 : 1.0,
              duration: const Duration(milliseconds: 120),
              child: SizedBox(
                width: widget.width ?? double.infinity,
                height: widget.height,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return widget.outlined
                        ? _buildOutlined(constraints)
                        : _buildFilled(constraints);
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilled(BoxConstraints constraints) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF8C00), Color(0xFFE77728)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8C00)
                      .withValues(alpha: _glowAnim.value),
                  blurRadius: _pressed ? 8 : 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const SizedBox.expand(),
          ),
          _buildContent(Colors.black, constraints.maxWidth),
        ],
      ),
    );
  }

  Widget _buildOutlined(BoxConstraints constraints) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Stack(
        alignment: Alignment.center,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: Colors.white.withValues(alpha: 0.04),
              border: Border.all(
                color: const Color(0xFFFF8C00).withValues(alpha: 0.5),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFFF8C00)
                      .withValues(alpha: _glowAnim.value * 0.15),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const SizedBox.expand(),
          ),
          _buildContent(const Color(0xFFFF8C00), constraints.maxWidth),
        ],
      ),
    );
  }

  Widget _buildContent(Color color, double buttonWidth) {
    // Show spinning logo when loading or flying away
    if (_showLogo) {
      // Fly distance: from center to right edge of button
      final flyDistance = buttonWidth / 2 + 16;

      return AnimatedBuilder(
        animation: Listenable.merge([_spinController, _flyController]),
        builder: (context, _) {
          final flyProgress = _flyController.value;
          // Use easeIn curve for acceleration feel
          final easedProgress = Curves.easeIn.transform(flyProgress);
          final xOffset = _flyingAway ? easedProgress * flyDistance : 0.0;

          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Smoke trail — only during fly
              if (_flyingAway && flyProgress > 0.0)
                ...List.generate(6, (i) {
                  // Each smoke puff trails behind at a fraction of the logo position
                  final trailFraction = (i + 1) / 7;
                  final smokeX = xOffset * (1.0 - trailFraction * 0.8);
                  final smokeOpacity = (0.5 - i * 0.08).clamp(0.0, 1.0) *
                      (1.0 - flyProgress).clamp(0.0, 1.0);
                  final smokeSize = 12.0 + i * 4.0;
                  // Slight vertical spread for organic feel
                  final smokeY = math.sin(i * 1.5 + flyProgress * 6) * 3.0;

                  return Transform.translate(
                    offset: Offset(smokeX - 10 - i * 8, smokeY),
                    child: Container(
                      width: smokeSize,
                      height: smokeSize,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.black.withValues(alpha: smokeOpacity * 0.6),
                            Colors.black.withValues(alpha: smokeOpacity * 0.2),
                            Colors.transparent,
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  );
                }),

              // The spinning logo
              Transform.translate(
                offset: Offset(xOffset, 0),
                child: RotationTransition(
                  turns: _spinController,
                  child: Image.asset(
                    'assets/images/icon_orange.png',
                    height: 32,
                    width: 32,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // Normal content
    if (widget.trailingIcon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.label,
            style: TextStyle(
              fontFamily: 'DarkerGrotesque',
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: color,
            ),
          ),
          const SizedBox(width: 8),
          Icon(widget.trailingIcon, size: 20, color: color),
        ],
      );
    }
    return Text(
      widget.label,
      style: TextStyle(
        fontFamily: 'DarkerGrotesque',
        fontSize: widget.fontSize,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: color,
      ),
    );
  }
}
