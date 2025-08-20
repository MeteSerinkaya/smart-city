import 'package:flutter/material.dart';

/// Reusable shimmer effect without external dependencies
class Shimmer extends StatefulWidget {
  final Widget child;
  final Color baseColor;
  final Color highlightColor;
  final Duration duration;

  const Shimmer({
    super.key,
    required this.child,
    this.baseColor = const Color(0xFFE5E7EB),
    this.highlightColor = const Color(0xFFF3F4F6),
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)..repeat();
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
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (Rect bounds) {
            final double width = bounds.width;
            final double dx = -width + (2 * width * _controller.value);
            final Rect shimmerRect = Rect.fromLTWH(dx, 0, 2 * width, bounds.height);
            return LinearGradient(
              colors: [widget.baseColor, widget.highlightColor, widget.baseColor],
              stops: const [0.35, 0.5, 0.65],
            ).createShader(shimmerRect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Simple rounded rectangle line placeholder
class SkeletonLine extends StatelessWidget {
  final double widthFactor;
  final double height;
  const SkeletonLine({super.key, required this.widthFactor, this.height = 12});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
