import 'package:flutter/material.dart';
import 'package:smart_city/core/components/lazy_loading/lazy_loading_widget.dart';

class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableLazyLoading;
  final Duration? lazyLoadingDelay;

  const OptimizedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.enableLazyLoading = true,
    this.lazyLoadingDelay,
  });

  String _getOptimizedImageUrl(String originalUrl) {
    // WebP format support
    if (originalUrl.contains('localhost:7276')) {
      // For local development, keep original format
      return originalUrl;
    }
    
    // For production, you can add WebP conversion logic here
    // Example: return originalUrl.replaceAll('.jpg', '.webp');
    return originalUrl;
  }

  String _getResponsiveImageUrl(String originalUrl, double? width) {
    if (width == null) return originalUrl;
    
    // Add responsive image parameters
    // This is a placeholder - implement based on your image service
    if (originalUrl.contains('localhost:7276')) {
      return originalUrl;
    }
    
    // For external image services like Cloudinary, Imgix, etc.
    // Example: return '$originalUrl?w=${width.toInt()}&q=80&format=webp';
    return originalUrl;
  }

  @override
  Widget build(BuildContext context) {
    final optimizedUrl = _getOptimizedImageUrl(imageUrl);
    final responsiveUrl = _getResponsiveImageUrl(optimizedUrl, width);

    Widget imageWidget = ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.zero,
      child: Image.network(
        responsiveUrl,
        width: width,
        height: height,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: borderRadius,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            loadingProgress.expectedTotalBytes!
                        : null,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${((loadingProgress.cumulativeBytesLoaded / 
                        (loadingProgress.expectedTotalBytes ?? 1)) * 100).toInt()}%',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: borderRadius,
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: Colors.grey),
                  SizedBox(height: 8),
                  Text('Resim yüklenemedi', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          );
        },
        // Memory optimization
        cacheWidth: width != null && width!.isFinite ? width!.toInt() : null,
        cacheHeight: height != null && height!.isFinite ? height!.toInt() : null,
        filterQuality: FilterQuality.medium,
      ),
    );

    if (enableLazyLoading) {
      return LazyLoadingWidget(
        delay: lazyLoadingDelay ?? const Duration(milliseconds: 100),
        placeholder: placeholder ?? Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: borderRadius,
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}

class HeroOptimizedImage extends StatelessWidget {
  final String imageUrl;
  final double height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const HeroOptimizedImage({
    super.key,
    required this.imageUrl,
    this.height = 600,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return OptimizedImage(
      imageUrl: imageUrl,
      width: double.infinity,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      enableLazyLoading: false, // Hero images should load immediately
      placeholder: Container(
        width: double.infinity,
        height: height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey[300]!,
              Colors.grey[400]!,
            ],
          ),
          borderRadius: borderRadius,
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
} 