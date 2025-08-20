import 'package:smart_city/core/service/news/news_service.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';

abstract class INewsRepository {
  Future<List<NewsModel>?> getNews();
  Future<NewsModel?> getNewsById(int id);
  Future<NewsModel?> addNews(NewsModel model);
  Future<NewsModel?> updateNews(NewsModel model);
  Future<bool> deleteNews(int id);
}

class NewsRepository extends INewsRepository {
  final INewsService _newsService;

  NewsRepository(this._newsService);

  @override
  Future<List<NewsModel>?> getNews() async {
    return await _newsService.fetchNews();
  }

  @override
  Future<NewsModel?> getNewsById(int id) async {
    return await _newsService.getNewsById(id);
  }

  @override
  Future<NewsModel?> addNews(NewsModel model) async {
    return await _newsService.addNews(model);
  }

  @override
  Future<NewsModel?> updateNews(NewsModel model) async {
    return await _newsService.updateNews(model);
  }

  @override
  Future<bool> deleteNews(int id) async {
    return await _newsService.deleteNews(id);
  }
}
