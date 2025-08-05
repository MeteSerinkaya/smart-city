import 'package:smart_city/core/service/search/search_service.dart';
import 'package:smart_city/view/authentication/test/model/searchmodel/search_model.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';
import 'package:smart_city/view/authentication/test/model/project/project_model.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';

abstract class ISearchRepository {
  Future<List<SearchModel>?> searchAll(String query);
  Future<List<NewsModel>?> searchNews(String query);
  Future<List<AnnouncementModel>?> searchAnnouncements(String query);
  Future<List<ProjectModel>?> searchProjects(String query);
  Future<List<CityServiceModel>?> searchCityServices(String query);
  Future<List<EventModel>?> searchEvents(String query);
}

class SearchRepository extends ISearchRepository {
  final ISearchService _searchService;

  SearchRepository(this._searchService);

  @override
  Future<List<SearchModel>?> searchAll(String query) async {
    return await _searchService.searchAll(query);
  }

  @override
  Future<List<NewsModel>?> searchNews(String query) async {
    return await _searchService.searchNews(query);
  }

  @override
  Future<List<AnnouncementModel>?> searchAnnouncements(String query) async {
    return await _searchService.searchAnnouncements(query);
  }

  @override
  Future<List<ProjectModel>?> searchProjects(String query) async {
    return await _searchService.searchProjects(query);
  }

  @override
  Future<List<CityServiceModel>?> searchCityServices(String query) async {
    return await _searchService.searchCityServices(query);
  }

  @override
  Future<List<EventModel>?> searchEvents(String query) async {
    return await _searchService.searchEvents(query);
  }
} 