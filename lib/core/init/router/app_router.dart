import 'package:go_router/go_router.dart';
import 'package:smart_city/core/constants/enums/locale_keys_enum.dart';
import 'package:smart_city/core/init/cache/locale_manager.dart';
import 'package:smart_city/view/home/home_view.dart';
import 'package:smart_city/view/view/admin/admin_panel_view.dart';
import 'package:smart_city/view/view/announcement/announcement_view.dart';
import 'package:smart_city/view/view/auth/login_view_nd.dart';
import 'package:smart_city/view/view/event/event_view.dart';
import 'package:smart_city/view/view/news/news_view.dart';
import 'package:smart_city/view/view/detail/announcement_detail_view.dart';
import 'package:smart_city/view/view/detail/event_detail_view.dart';
import 'package:smart_city/view/view/detail/news_detail_view.dart';
import 'package:smart_city/view/view/detail/city_service_detail_view.dart';
import 'package:smart_city/view/view/detail/project_detail_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/home', // Direkt home'a yönlendir
  redirect: (context, state) {
    final token = LocaleManager.instance.getStringValue(PreferencesKeys.TOKEN);
    final isAdmin = LocaleManager.instance.getBoolValue(PreferencesKeys.IS_ADMIN);
    final loggingIn = state.uri.path == '/login';
    final adminLogin = state.uri.path == '/admin-login';
    final adminPanel = state.uri.path == '/admin';

    // Admin paneli için token kontrolü
    if (adminPanel && (token == null || token.isEmpty || isAdmin == false)) {
      return '/admin-login';
    }

    // Admin login sayfasında token varsa admin paneline yönlendir
    if (adminLogin && token != null && token.isNotEmpty && isAdmin == true) {
      return '/admin';
    }

    // Normal login sayfasına erişimi engelle (sadece admin paneli için)
    if (loggingIn) {
      return '/home';
    }

    return null; // erişim serbest
  },
  routes: [
    GoRoute(path: '/home', builder: (context, state) => const HomeScreenView()),
    GoRoute(path: '/admin-login', builder: (context, state) => const LoginViewNd()),
    GoRoute(path: '/news', builder: (context, state) => const NewsView()),
    GoRoute(path: '/events', builder: (context, state) => const EventView()),
    GoRoute(path: '/announcements', builder: (context, state) => const AnnouncementView()),
    GoRoute(path: '/admin', builder: (context, state) => const AdminPanelView()),
    // Detay sayfaları
    GoRoute(path: '/announcements-detail', builder: (context, state) => const AnnouncementDetailView()),
    GoRoute(path: '/events-detail', builder: (context, state) => const EventDetailView()),
    GoRoute(path: '/news-detail', builder: (context, state) => const NewsDetailView()),
    GoRoute(path: '/city-services-detail', builder: (context, state) => const CityServiceDetailView()),
    GoRoute(path: '/projects-detail', builder: (context, state) => const ProjectDetailView()),
  ],
);
