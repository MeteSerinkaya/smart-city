import 'package:smart_city/core/init/network/network_manager.dart';
import 'package:smart_city/core/constants/app/app_constants.dart';
import 'package:smart_city/view/authentication/test/model/searchmodel/search_model.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';
import 'package:smart_city/view/authentication/test/model/project/project_model.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';

abstract class ISearchService {
  Future<List<SearchModel>?> searchAll(String query);
  Future<List<NewsModel>?> searchNews(String query);
  Future<List<AnnouncementModel>?> searchAnnouncements(String query);
  Future<List<ProjectModel>?> searchProjects(String query);
  Future<List<CityServiceModel>?> searchCityServices(String query);
  Future<List<EventModel>?> searchEvents(String query);
}

class SearchService extends ISearchService {
    String _buildFullImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) return '';
 
    // Eğer zaten tam URL ise (http:// veya https:// ile başlıyorsa) direkt döndür
    if (imagePath.startsWith('http://') || imagePath.startsWith('https://')) {
      print('🔍 FULL URL (zaten tam): $imagePath');
      return imagePath;
    }
 
    // Relative path ise base URL ile birleştir
    final baseUrl = AppConstants.baseUrl;
    // Base URL'in sonunda / varsa kaldır, relative path'in başında / varsa kaldır
    final cleanBaseUrl = baseUrl.endsWith('/') ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;
    final cleanImagePath = imagePath.startsWith('/') ? imagePath.substring(1) : imagePath;
    final fullUrl = '$cleanBaseUrl/$cleanImagePath';
    
    print('🔍 RELATIVE PATH: $imagePath');
    print('🔍 BASE URL: $baseUrl');
    print('🔍 CLEAN BASE URL: $cleanBaseUrl');
    print('🔍 CLEAN IMAGE PATH: $cleanImagePath');
    print('🔍 FULL URL (oluşturulan): $fullUrl');
    return fullUrl;
  }

  @override
  Future<List<SearchModel>?> searchAll(String query) async {
    try {
      // Use the new unified search endpoint
      final response = await NetworkManager.instance.dio.get('search', queryParameters: {'query': query});

      if (response.statusCode == 200 && response.data != null) {
        final results = <SearchModel>[];
        final data = response.data;

        // Add news results
        if (data['news'] != null) {
          for (var news in data['news']) {
            final newsImageUrl = _buildFullImageUrl(
              news['imageUrl'] ?? news['image'] ?? news['heroImageUrl'] ?? news['heroImage'],
            );
            print('🔍 NEWS FINAL imageUrl: $newsImageUrl');
            
            results.add(
              SearchModel(
                id: news['id'],
                title: news['title'],
                content: news['content'],
                // Relative path'i tam URL'e çevir
                imageUrl: newsImageUrl,
                type: 'news',
                publishedAt: news['publishedAt'] != null ? DateTime.tryParse(news['publishedAt']) : null,
              ),
            );
          }
        }

        // Add announcement results
        if (data['announcements'] != null) {
          for (var announcement in data['announcements']) {
            results.add(
              SearchModel(
                id: announcement['id'],
                title: announcement['title'],
                content: announcement['content'],
                // AnnouncementModel'de image alanı yok
                type: 'announcement',
                date: announcement['date'] != null ? DateTime.tryParse(announcement['date']) : null,
              ),
            );
          }
        }

        // Add project results
        if (data['projects'] != null) {
          for (var project in data['projects']) {
            final projectImageUrl = _buildFullImageUrl(
              project['imageUrl'] ?? project['image'] ?? project['heroImageUrl'] ?? project['heroImage'],
            );
            print('🔍 PROJECT FINAL imageUrl: $projectImageUrl');
            
            results.add(
              SearchModel(
                id: project['id'],
                title: project['title'],
                description: project['description'],
                // Relative path'i tam URL'e çevir
                imageUrl: projectImageUrl,
                type: 'project',
              ),
            );
          }
        }

        // Add city service results
        if (data['cityServices'] != null) {
          for (var service in data['cityServices']) {
            final serviceIconUrl = _buildFullImageUrl(service['iconUrl']);
            print('🔍 CITY SERVICE FINAL iconUrl: $serviceIconUrl');
            
            results.add(
              SearchModel(
                id: service['id'],
                title: service['title'],
                description: service['description'],
                // Şehir hizmetleri için iconUrl'i imageUrl olarak kullan
                imageUrl: serviceIconUrl,
                iconUrl: serviceIconUrl,
                type: 'city_service',
              ),
            );
          }
        }

        // Add event results
        if (data['events'] != null) {
          for (var event in data['events']) {
            results.add(
              SearchModel(
                id: event['id'],
                title: event['title'],
                description: event['description'],
                // Relative path'i tam URL'e çevir
                imageUrl: _buildFullImageUrl(
                  event['imageUrl'] ?? event['image'] ?? event['heroImageUrl'] ?? event['heroImage'],
                ),
                type: 'event',
                date: event['date'] != null ? DateTime.tryParse(event['date']) : null,
              ),
            );
          }
        }

        return results;
      }
      return null;
    } catch (e) {
      print("SearchService searchAll error: $e");
      return null;
    }
  }

  @override
  Future<List<NewsModel>?> searchNews(String query) async {
    try {
      final response = await NetworkManager.instance.dioGet('news', NewsModel());
      if (response != null && response is List) {
        final allNews = response.cast<NewsModel>();
        return allNews.where((news) {
          final title = news.title?.toLowerCase() ?? '';
          final content = news.content?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery) || content.contains(searchQuery);
        }).toList();
      }
      return null;
    } catch (e) {
      print("SearchService searchNews error: $e");
      return null;
    }
  }

  @override
  Future<List<AnnouncementModel>?> searchAnnouncements(String query) async {
    try {
      final response = await NetworkManager.instance.dioGet('announcements', AnnouncementModel());
      if (response != null && response is List) {
        final allAnnouncements = response.cast<AnnouncementModel>();
        return allAnnouncements.where((announcement) {
          final title = announcement.title?.toLowerCase() ?? '';
          final content = announcement.content?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery) || content.contains(searchQuery);
        }).toList();
      }
      return null;
    } catch (e) {
      print("SearchService searchAnnouncements error: $e");
      return null;
    }
  }

  @override
  Future<List<ProjectModel>?> searchProjects(String query) async {
    try {
      final response = await NetworkManager.instance.dioGet('projects', ProjectModel());
      if (response != null && response is List) {
        final allProjects = response.cast<ProjectModel>();
        return allProjects.where((project) {
          final title = project.title?.toLowerCase() ?? '';
          final description = project.description?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery) || description.contains(searchQuery);
        }).toList();
      }
      return null;
    } catch (e) {
      print("SearchService searchProjects error: $e");
      return null;
    }
  }

  @override
  Future<List<CityServiceModel>?> searchCityServices(String query) async {
    try {
      final response = await NetworkManager.instance.dioGet('city-services', CityServiceModel());
      if (response != null && response is List) {
        final allServices = response.cast<CityServiceModel>();
        return allServices.where((service) {
          final title = service.title?.toLowerCase() ?? '';
          final description = service.description?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery) || description.contains(searchQuery);
        }).toList();
      }
      return null;
    } catch (e) {
      print("SearchService searchCityServices error: $e");
      return null;
    }
  }

  @override
  Future<List<EventModel>?> searchEvents(String query) async {
    try {
      final response = await NetworkManager.instance.dioGet('events', EventModel());
      if (response != null && response is List) {
        final allEvents = response.cast<EventModel>();
        return allEvents.where((event) {
          final title = event.title?.toLowerCase() ?? '';
          final description = event.description?.toLowerCase() ?? '';
          final searchQuery = query.toLowerCase();
          return title.contains(searchQuery) || description.contains(searchQuery);
        }).toList();
      }
      return null;
    } catch (e) {
      print("SearchService searchEvents error: $e");
      return null;
    }
  }
}
