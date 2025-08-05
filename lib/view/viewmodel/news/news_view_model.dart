import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/news/news_repository.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';

part 'news_view_model.g.dart';

class NewsViewModel = _NewsViewModelBase with _$NewsViewModel;

abstract class _NewsViewModelBase with Store {
  final INewsRepository _newsRepository;

  _NewsViewModelBase(this._newsRepository);

  @observable
  bool isLoading = false;

  @observable
  List<NewsModel>? newsList;

  @action
  Future<void> fetchNews() async {
    isLoading = true;
    newsList = await _newsRepository.getNews();
    isLoading = false;
  }

  @action
  Future<bool> addNews(NewsModel model) async {
    isLoading = true;
    final result = await _newsRepository.addNews(model);
    await fetchNews();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> updateNews(NewsModel model) async {
    isLoading = true;
    final result = await _newsRepository.updateNews(model);
    await fetchNews();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> deleteNews(int id) async {
    isLoading = true;
    final result = await _newsRepository.deleteNews(id);
    await fetchNews();
    isLoading = false;
    return result;
  }
}
