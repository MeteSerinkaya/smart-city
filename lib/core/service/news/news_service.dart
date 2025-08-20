import 'package:smart_city/core/init/network/network_manager.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';

abstract class INewsService {
  Future<List<NewsModel>?> fetchNews();
  Future<NewsModel?> getNewsById(int id);
  Future<NewsModel?> addNews(NewsModel model);
  Future<NewsModel?> updateNews(NewsModel model);
  Future<bool> deleteNews(int id);
}

class NewsService extends INewsService {
  @override
  Future<List<NewsModel>?> fetchNews() async {
    try {
      // Tüm haberleri almak için sınırsız pageSize kullan
      final response = await NetworkManager.instance.dioGet('news?pageSize=1000', NewsModel());
      if (response != null && response is List) {
        return response.cast<NewsModel>();
      }
      return null;
    } catch (e) {
      print("NewsService fetchNews error: $e");
      return null;
    }
  }

  @override
  Future<NewsModel?> getNewsById(int id) async {
    try {
      final response = await NetworkManager.instance.dioGet('news/$id', NewsModel());
      if (response != null && response is NewsModel) {
        return response;
      }
      return null;
    } catch (e) {
      print("NewsService getNewsById error: $e");
      return null;
    }
  }

  // Tüm haberleri almak için yeni metod
  Future<List<NewsModel>?> fetchAllNews() async {
    try {
      final response = await NetworkManager.instance.dioGet('news/all', NewsModel());
      if (response != null && response is List) {
        return response.cast<NewsModel>();
      }
      return null;
    } catch (e) {
      print("NewsService fetchAllNews error: $e");
      return null;
    }
  }

  @override
  Future<NewsModel?> addNews(NewsModel model) async {
    try {
      final data = model.toJson();
      data.remove('id');
      final response = await NetworkManager.instance.dio.post('news', data: data);
      
      if (response.statusCode == 201) {
        return NewsModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("NewsService addNews error: $e");
      return null;
    }
  }

  @override
  Future<NewsModel?> updateNews(NewsModel model) async {
    try {
      final response = await NetworkManager.instance.dio.put('news/${model.id}', data: model.toJson());
      
      if (response.statusCode == 204) {
        return model; // PUT returns 204 No Content, so return the updated model
      }
      return null;
    } catch (e) {
      print("NewsService updateNews error: $e");
      return null;
    }
  }

  @override
  Future<bool> deleteNews(int id) async {
    try {
      final response = await NetworkManager.instance.dio.delete('news/$id');
      return response.statusCode == 204;
    } catch (e) {
      print("NewsService deleteNews error: $e");
      return false;
    }
  }
}
