import 'package:flutter/material.dart';

class LazyRoute extends StatefulWidget {
  final Future<Widget> Function() builder;
  final Widget? placeholder;
  final Duration? loadingDelay;

  const LazyRoute({
    super.key,
    required this.builder,
    this.placeholder,
    this.loadingDelay,
  });

  @override
  State<LazyRoute> createState() => _LazyRouteState();
}

class _LazyRouteState extends State<LazyRoute> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget>(
      future: widget.builder(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return widget.placeholder ?? const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sayfa yükleniyor...'),
                ],
              ),
            ),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  const Text('Sayfa yüklenirken hata oluştu'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry loading
                      setState(() {});
                    },
                    child: const Text('Tekrar Dene'),
                  ),
                ],
              ),
            ),
          );
        }

        return snapshot.data ?? const Scaffold(
          body: Center(
            child: Text('Sayfa bulunamadı'),
          ),
        );
      },
    );
  }
}

// Route-based lazy loading helpers
class LazyRoutes {
  static Future<Widget> announcementRoute() async {
    // Simulate loading delay for better UX
    await Future.delayed(const Duration(milliseconds: 300));
    return const AnnouncementView();
  }

  static Future<Widget> eventRoute() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const EventView();
  }

  static Future<Widget> newsRoute() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const NewsView();
  }

  static Future<Widget> cityServicesRoute() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const CityServicesView();
  }

  static Future<Widget> adminLoginRoute() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const AdminLoginView();
  }

  static Future<Widget> adminPanelRoute() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return const AdminPanelView();
  }
}

// Placeholder imports - these will be replaced with actual imports
class AnnouncementView extends StatelessWidget {
  const AnnouncementView({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('Announcements'));
}

class EventView extends StatelessWidget {
  const EventView({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('Events'));
}

class NewsView extends StatelessWidget {
  const NewsView({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('News'));
}

class CityServicesView extends StatelessWidget {
  const CityServicesView({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('City Services'));
}

class AdminLoginView extends StatelessWidget {
  const AdminLoginView({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('Admin Login'));
}

class AdminPanelView extends StatelessWidget {
  const AdminPanelView({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Text('Admin Panel'));
} 