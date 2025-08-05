import 'package:flutter/material.dart';

class LazyLoadingWidget extends StatefulWidget {
  final Widget child;
  final double threshold;
  final Duration delay;
  final Widget? placeholder;

  const LazyLoadingWidget({
    super.key,
    required this.child,
    this.threshold = 0.1,
    this.delay = Duration.zero,
    this.placeholder,
  });

  @override
  State<LazyLoadingWidget> createState() => _LazyLoadingWidgetState();
}

class _LazyLoadingWidgetState extends State<LazyLoadingWidget> {
  bool _isVisible = false;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkVisibility();
    });
  }

  void _checkVisibility() {
    if (!mounted) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;
    final screenHeight = MediaQuery.of(context).size.height;

    // Check if widget is visible in viewport
    final isVisible = position.dy < screenHeight * (1 + widget.threshold) &&
        position.dy + size.height > -size.height * widget.threshold;

    if (isVisible && !_isVisible) {
      setState(() => _isVisible = true);
      
      // Add delay before loading
      Future.delayed(widget.delay, () {
        if (mounted) {
          setState(() => _isLoaded = true);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        _checkVisibility();
        return false;
      },
      child: _isLoaded
          ? widget.child
          : widget.placeholder ?? const SizedBox.shrink(),
    );
  }
}

class LazyImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const LazyImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LazyLoadingWidget(
      placeholder: placeholder ?? Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
      child: Image.network(
        imageUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.error),
          );
        },
      ),
    );
  }
} 