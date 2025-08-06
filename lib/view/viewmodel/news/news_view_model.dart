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
      if (result != null && result.isNotEmpty) {
        newsList = result;
      } else {
        // API yanıt vermezse veya boş data gelirse hemen boş state'e geç
        newsList = [];
        hasError = false; // Error state gösterme, boş state göster
        errorMessage = null;
      }
    } catch (e) {
      // Hata durumunda da boş state'e geç, error state gösterme
      hasError = false;
      errorMessage = null;
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
      return false;
    } finally {
      isLoading = false;
    }
  }
}
