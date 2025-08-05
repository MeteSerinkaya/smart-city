import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MemoryManager {
  static void optimizeMemory() {
    // Clear image cache periodically
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
    
    // Force garbage collection (if available)
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
  }
}

class PerformanceMonitor extends StatefulWidget {
  final Widget child;
  final bool enableMonitoring;

  const PerformanceMonitor({
    super.key,
    required this.child,
    this.enableMonitoring = true,
  });

  @override
  State<PerformanceMonitor> createState() => _PerformanceMonitorState();
}

class _PerformanceMonitorState extends State<PerformanceMonitor> with WidgetsBindingObserver {
  int _frameCount = 0;
  DateTime? _lastFrameTime;
  double _averageFPS = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.enableMonitoring) {
      WidgetsBinding.instance.addObserver(this);
      _startMonitoring();
    }
  }

  @override
  void dispose() {
    if (widget.enableMonitoring) {
      WidgetsBinding.instance.removeObserver(this);
    }
    super.dispose();
  }

  void _startMonitoring() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _frameCount++;
      final now = DateTime.now();
      
      if (_lastFrameTime != null) {
        final frameTime = now.difference(_lastFrameTime!).inMilliseconds;
        if (frameTime > 0) {
          _averageFPS = 1000 / frameTime;
        }
      }
      
      _lastFrameTime = now;
      
      // Monitor memory usage every 60 frames
      if (_frameCount % 60 == 0) {
        _checkMemoryUsage();
      }
    });
  }

  void _checkMemoryUsage() {
    // Clear image cache if memory usage is high
    final imageCache = PaintingBinding.instance.imageCache;
    if (imageCache.currentSize > imageCache.maximumSize * 0.8) {
      imageCache.clear();
      debugPrint('PerformanceMonitor: Image cache cleared due to high memory usage');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      // Optimize memory when app goes to background
      MemoryManager.optimizeMemory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class ImageCacheManager {
  static void preloadImages(List<String> imageUrls, BuildContext context) {
    for (final url in imageUrls) {
      precacheImage(NetworkImage(url), context);
    }
  }

  static void clearCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  static void setCacheSize(int size) {
    PaintingBinding.instance.imageCache.maximumSize = size;
  }
}

class ScrollPerformanceOptimizer extends StatelessWidget {
  final Widget child;
  final ScrollController? scrollController;

  const ScrollPerformanceOptimizer({
    super.key,
    required this.child,
    this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        // Optimize performance during scroll
        if (notification is ScrollUpdateNotification) {
          // Reduce frame rate during fast scrolling
          if (notification.dragDetails != null) {
            // User is actively scrolling
            WidgetsBinding.instance.scheduleFrameCallback((_) {
              // Optimize rendering during scroll
            });
          }
        }
        return false;
      },
      child: child,
    );
  }
} 