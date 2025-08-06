import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class SmartLoadingWidget extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final VoidCallback? onRetry;
  final Widget child;
  final Duration timeout;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const SmartLoadingWidget({
    super.key,
    required this.isLoading,
    required this.hasError,
    this.errorMessage,
    this.onRetry,
    required this.child,
    this.timeout = const Duration(seconds: 15),
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingWidget ?? _buildDefaultLoadingWidget();
    }

    if (hasError) {
      return errorWidget ?? _buildDefaultErrorWidget(context);
    }

    return child;
  }

  Widget _buildDefaultLoadingWidget() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          const SizedBox(height: 16),
          Text(
            'Veriler yükleniyor...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Lütfen bekleyin',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultErrorWidget(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Bir hata oluştu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              errorMessage ?? 'Veriler yüklenirken bir hata oluştu.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (onRetry != null)
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Tekrar Dene'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
        ],
      ),
    );
  }
}

// Timeout aware loading widget
class TimeoutAwareLoadingWidget extends StatefulWidget {
  final Future<void> Function() onLoad;
  final Widget child;
  final Duration timeout;
  final Widget? loadingWidget;
  final Widget? errorWidget;

  const TimeoutAwareLoadingWidget({
    super.key,
    required this.onLoad,
    required this.child,
    this.timeout = const Duration(seconds: 15),
    this.loadingWidget,
    this.errorWidget,
  });

  @override
  State<TimeoutAwareLoadingWidget> createState() => _TimeoutAwareLoadingWidgetState();
}

class _TimeoutAwareLoadingWidgetState extends State<TimeoutAwareLoadingWidget> {
  bool isLoading = true;
  bool hasError = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        isLoading = true;
        hasError = false;
        errorMessage = null;
      });

      await widget.onLoad().timeout(
        widget.timeout,
        onTimeout: () {
          throw TimeoutException('İşlem zaman aşımına uğradı');
        },
      );

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    } on TimeoutException catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = e.toString();
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          hasError = true;
          errorMessage = 'Beklenmeyen bir hata oluştu: $e';
        });
      }
    }
  }

  void _retry() {
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return SmartLoadingWidget(
      isLoading: isLoading,
      hasError: hasError,
      errorMessage: errorMessage,
      onRetry: _retry,
      child: widget.child,
      loadingWidget: widget.loadingWidget,
      errorWidget: widget.errorWidget,
    );
  }
}

class TimeoutException implements Exception {
  final String message;
  TimeoutException(this.message);
  
  @override
  String toString() => message;
} 