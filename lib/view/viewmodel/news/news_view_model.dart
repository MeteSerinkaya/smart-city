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

  @observable
  String? errorMessage;

  @observable
  bool hasError = false;

  @action
  Future<void> fetchNews() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _newsRepository.getNews();
      if (result != null) {
        newsList = result;
      } else {
        newsList = [];
        hasError = true;
        errorMessage = "Veri yüklenemedi. Lütfen tekrar deneyin.";
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      newsList = [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> retryFetchNews() async {
    await fetchNews();
  }

  @action
  Future<bool> addNews(NewsModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _newsRepository.addNews(model);
      if (result != null) {
        await fetchNews();
        return true;
      } else {
        hasError = true;
        errorMessage = "Haber eklenemedi. Lütfen tekrar deneyin.";
        return false;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateNews(NewsModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _newsRepository.updateNews(model);
      if (result != null) {
        await fetchNews();
        return true;
      } else {
        hasError = true;
        errorMessage = "Haber güncellenemedi. Lütfen tekrar deneyin.";
        return false;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteNews(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _newsRepository.deleteNews(id);
      if (result) {
        await fetchNews();
        return true;
      } else {
        hasError = true;
        errorMessage = "Haber silinemedi. Lütfen tekrar deneyin.";
        return false;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }
}
