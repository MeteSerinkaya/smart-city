import 'package:flutter/material.dart';
import 'package:smart_city/core/components/optimized_image/optimized_image.dart';

class ParallaxHero extends StatefulWidget {
  final String imageUrl;
  final Widget child;
  final double height;
  final ScrollController? scrollController;

  const ParallaxHero({
    super.key,
    required this.imageUrl,
    required this.child,
    this.height = 600,
    this.scrollController,
  });

  @override
  State<ParallaxHero> createState() => _ParallaxHeroState();
}

class _ParallaxHeroState extends State<ParallaxHero> {
  double _offset = 0.0;

  @override
  void initState() {
    super.initState();
    widget.scrollController?.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.scrollController?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (widget.scrollController != null) {
      setState(() {
        _offset = widget.scrollController!.offset * 0.5; // Parallax speed
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Stack(
        children: [
          // Parallax Background
          Positioned(
            top: -_offset,
            left: 0,
            right: 0,
            bottom: -_offset,
            child: HeroOptimizedImage(imageUrl: widget.imageUrl, height: widget.height, fit: BoxFit.cover),
          ),
          // Gradient Overlay
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(102, 30, 64, 175), Color.fromARGB(179, 7, 7, 7)],
                stops: [0.0, 1.0],
              ),
            ),
          ),
          // Content
          widget.child,
        ],
      ),
    );
  }
}
