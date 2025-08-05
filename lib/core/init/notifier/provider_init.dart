import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smart_city/core/repository/announcements/announcement_repository.dart';
import 'package:smart_city/core/repository/auth/auth_repository.dart';
import 'package:smart_city/core/repository/event/event_repository.dart';
import 'package:smart_city/core/repository/heroimage/hero_image_repository.dart';
import 'package:smart_city/core/repository/news/news_repository.dart';
import 'package:smart_city/core/service/announcements/announcement_service.dart';
import 'package:smart_city/core/service/auth/auth_service.dart';
import 'package:smart_city/core/service/event/event_service.dart';
import 'package:smart_city/core/service/heroimage/hero_image_service.dart';
import 'package:smart_city/core/service/news/news_service.dart';
import 'package:smart_city/view/viewmodel/announcement/announcement_view_model.dart';
import 'package:smart_city/view/viewmodel/auth/auth_view_model.dart';
import 'package:smart_city/view/viewmodel/event/event_view_model.dart';
import 'package:smart_city/view/viewmodel/heroimage/hero_image_view_model.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';

class ProviderInit {
  static List<SingleChildWidget> providers = [
    //NewsViewModel, Service ve Repository injection ile birlikte projeye dahil olur.
    Provider<INewsService>(create: (_) => NewsService()),
    ProxyProvider<INewsService, INewsRepository>(update: (_, newsService, __) => NewsRepository(newsService)),
    ProxyProvider<INewsRepository, NewsViewModel>(update: (_, newsRepository, __) => NewsViewModel(newsRepository)),
    //EventViewModel, Service ve Repository injection ile birlikte projeye dahil olur.
    Provider<IEventService>(create: (_) => EventService()),
    ProxyProvider<IEventService, IEventRepository>(update: (_, eventService, __) => EventRepository(eventService)),
    ProxyProvider<IEventRepository, EventViewModel>(
      update: (_, eventRepository, __) => EventViewModel(eventRepository),
    ),
    //AnnouncementViewModel, Service ve Repository injection ile birlikte projeye dahil olur.
    Provider<IAnnouncementService>(create: (_) => AnnouncementService()),
    ProxyProvider<IAnnouncementService, IAnnouncementRepository>(
      update: (_, announcementService, _) => AnnouncementRepository(announcementService),
    ),
    ProxyProvider<IAnnouncementRepository, AnnouncementViewModel>(
      update: (_, announcementRepository, _) => AnnouncementViewModel(announcementRepository),
    ),
    //AuthViewModel, Service ve Repository injection ile birlikte projeye dahil olur.
    Provider<IAuthService>(create: (_) => AuthService()),
    ProxyProvider<IAuthService, IAuthRepository>(update: (_, authService, __) => AuthRepository(authService)),
    ProxyProvider<IAuthRepository, AuthViewModel>(update: (_, authRepository, __) => AuthViewModel(authRepository)),
    //HeroImageViewModel, Service ve Repository injection ile birlikte projeye dahil olur.
    Provider<IHeroImageService>(create: (_) => HeroImageService()),
    ProxyProvider<IHeroImageService, IHeroImageRepository>(
      update: (_, heroImageService, __) => HeroImageRepository(heroImageService),
    ),
    ProxyProvider<IHeroImageRepository, HeroImageViewModel>(
      update: (_, heroImageRepository, __) => HeroImageViewModel(heroImageRepository, HeroImageService()),
    ),
  ];
}
