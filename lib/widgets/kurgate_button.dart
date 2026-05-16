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
    with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnim;

  bool _pressed = false;

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
  }

  @override
  void didUpdateWidget(covariant KurgateButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isSuccess && !oldWidget.isSuccess) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        widget.onSuccessAnimComplete?.call();
      });
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enabled =
        widget.onPressed != null && !widget.isLoading && !widget.isSuccess;

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
                  color: const Color(
                    0xFFFF8C00,
                  ).withValues(alpha: _glowAnim.value),
                  blurRadius: _pressed ? 8 : 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const SizedBox.expand(),
          ),
          _buildContent(Colors.black),
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
                  color: const Color(
                    0xFFFF8C00,
                  ).withValues(alpha: _glowAnim.value * 0.15),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const SizedBox.expand(),
          ),
          _buildContent(const Color(0xFFFF8C00)),
        ],
      ),
    );
  }

  Widget _buildContent(Color color) {
    // Show spinner when loading
    if (widget.isLoading) {
      return SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: color,
        ),
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

