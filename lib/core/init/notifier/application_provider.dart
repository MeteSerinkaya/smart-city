import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:smart_city/core/init/notifier/theme_notifier.dart';
import 'package:smart_city/core/repository/announcements/announcement_repository.dart';
import 'package:smart_city/core/repository/auth/auth_repository.dart';
import 'package:smart_city/core/repository/cityservice/city_service_repository.dart';
import 'package:smart_city/core/repository/event/event_repository.dart';
import 'package:smart_city/core/repository/heroimage/hero_image_repository.dart';
import 'package:smart_city/core/repository/news/news_repository.dart';
import 'package:smart_city/core/repository/project/project_repository.dart';
import 'package:smart_city/core/service/announcements/announcement_service.dart';
import 'package:smart_city/core/service/auth/auth_service.dart';
import 'package:smart_city/core/service/cityservice/city_service_service.dart';
import 'package:smart_city/core/service/event/event_service.dart';
import 'package:smart_city/core/service/heroimage/hero_image_service.dart';
import 'package:smart_city/core/service/news/news_service.dart';
import 'package:smart_city/core/service/project/project_service.dart';
import 'package:smart_city/view/viewmodel/announcement/announcement_view_model.dart';
import 'package:smart_city/view/viewmodel/auth/auth_view_model.dart';
import 'package:smart_city/view/viewmodel/city/city_service_view_model.dart';
import 'package:smart_city/view/viewmodel/event/event_view_model.dart';
import 'package:smart_city/view/viewmodel/heroimage/hero_image_view_model.dart';
import 'package:smart_city/view/viewmodel/news/news_view_model.dart';
import 'package:smart_city/view/viewmodel/project/project_view_model.dart';

class ApplicationProvider {
  static final ApplicationProvider _instance = ApplicationProvider._init();
  static ApplicationProvider get instance => _instance;

  ApplicationProvider._init();

  late final IAuthRepository _authRepository = AuthRepository(AuthService());
  late final IAnnouncementRepository _announcementRepository = AnnouncementRepository(
    AnnouncementService(),
  );
  late final ICityServiceRepository _cityServiceRepository = CityServiceRepository(
    CityServiceService(),
  );
  late final IEventRepository _eventRepository = EventRepository(EventService());
  late final INewsRepository _newsRepository = NewsRepository(NewsService());
  late final IHeroImageRepository _heroImageRepository = HeroImageRepository(HeroImageService());
  late final IHeroImageService _heroImageService = HeroImageService();
  late final IProjectRepository _projectRepository = ProjectRepository(ProjectService());

  List<SingleChildWidget> singleItems = [];

  List<SingleChildWidget> dependItems = [
    ChangeNotifierProvider(create: (context) => ThemeNotifier()),
    Provider<AuthViewModel>(create: (context) => AuthViewModel(_instance._authRepository)),
    Provider<AnnouncementViewModel>(create: (context) => AnnouncementViewModel(_instance._announcementRepository)),
    Provider<CityServiceViewModel>(create: (context) => CityServiceViewModel(_instance._cityServiceRepository)),
    Provider<EventViewModel>(create: (context) => EventViewModel(_instance._eventRepository)),
    Provider<NewsViewModel>(create: (context) => NewsViewModel(_instance._newsRepository)),
    Provider<HeroImageViewModel>(create: (context) => HeroImageViewModel(_instance._heroImageRepository, _instance._heroImageService)),
    Provider<ProjectViewModel>(create: (context) => ProjectViewModel(_instance._projectRepository)),
  ];

  List<SingleChildWidget> uiChangesItems = [];
}
