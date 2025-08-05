import 'package:flutter/material.dart';

class SkeletonLoading extends StatefulWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Color? color;

  const SkeletonLoading({super.key, this.width = double.infinity, this.height = 20, this.borderRadius = 8, this.color});

  @override
  State<SkeletonLoading> createState() => _SkeletonLoadingState();
}

class _SkeletonLoadingState extends State<SkeletonLoading> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 1500), vsync: this);
    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                (widget.color ?? Colors.grey[300]!).withOpacity(0.6),
                (widget.color ?? Colors.grey[300]!).withOpacity(0.3),
                (widget.color ?? Colors.grey[300]!).withOpacity(0.6),
              ],
              stops: [_animation.value - 0.3, _animation.value, _animation.value + 0.3],
            ),
          ),
        );
      },
    );
  }
}

class HeroSkeletonLoading extends StatelessWidget {
  const HeroSkeletonLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 600,
      color: Colors.grey[200],
      child: Stack(
        children: [
          // Background skeleton
          const SkeletonLoading(width: double.infinity, height: 600, borderRadius: 0),
          // Content skeleton
          Positioned(
            left: 48,
            top: 0,
            bottom: 0,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title skeleton
                    const SkeletonLoading(width: 400, height: 56, borderRadius: 8),
                    const SizedBox(height: 16),
                    // Description skeleton
                    const SkeletonLoading(width: 300, height: 20, borderRadius: 4),
                    const SizedBox(height: 8),
                    const SkeletonLoading(width: 250, height: 20, borderRadius: 4),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
