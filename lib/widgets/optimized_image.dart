import 'package:flutter/material.dart';

/// Optimized image widget that reduces memory by constraining
/// the decode size to match the display size.
class OptimizedImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final double? width;
  final double? height;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const OptimizedImage({
    super.key,
    required this.assetPath,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    // Use the device pixel ratio to compute the real decode size
    final dpr = MediaQuery.of(context).devicePixelRatio;
    final cw = width != null ? (width! * dpr).toInt() : null;
    final ch = height != null ? (height! * dpr).toInt() : null;

    return Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      cacheWidth: cw ?? 800,   // max decode width
      cacheHeight: ch,
      errorBuilder: errorBuilder ?? _defaultError,
      // Use gapless playback to avoid flickering
      gaplessPlayback: true,
      // Filter quality reduced for thumbnails
      filterQuality: FilterQuality.low,
    );
  }

  static Widget _defaultError(
    BuildContext context, Object error, StackTrace? stack) {
    return Container(
      color: const Color(0xFF2A2A2A),
      child: const Center(
        child: Icon(Icons.image, size: 30, color: Color(0xFF555555)),
      ),
    );
  }
}
