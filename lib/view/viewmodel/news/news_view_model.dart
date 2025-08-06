import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/news/news_repository.dart';
import 'package:smart_city/view/authentication/test/model/newsmodel/news_model.dart';
import 'package:smart_city/core/init/network/network_manager.dart';

part 'news_view_model.g.dart';

class NewsViewModel = _NewsViewModelBase with _$NewsViewModel;

abstract class _NewsViewModelBase with Store {
  final INewsRepository _newsRepository;

  _NewsViewModelBase(this._newsRepository);

  @observable
  bool isLoading = false;

  @observable
  bool hasError = false;

  @observable
  String errorMessage = '';

  @observable
  List<NewsModel>? newsList;

  @action
  Future<void> fetchNews() async {
    try {
      isLoading = true;
      hasError = false;
      errorMessage = '';
      
      final result = await _newsRepository.getNews();
      
      if (result != null) {
        newsList = result;
      } else {
        hasError = true;
        errorMessage = 'Veri yüklenemedi. Lütfen tekrar deneyin.';
      }
    } on TimeoutException catch (e) {
      hasError = true;
      errorMessage = e.toString();
      print('NewsViewModel fetchNews timeout: $e');
    } catch (e) {
      hasError = true;
      errorMessage = 'Beklenmeyen bir hata oluştu: $e';
      print('NewsViewModel fetchNews error: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> addNews(NewsModel model) async {
    try {
      isLoading = true;
      hasError = false;
      errorMessage = '';
      
      final result = await _newsRepository.addNews(model);
      
      if (result != null) {
        await fetchNews(); // Refresh the list
        return true;
      } else {
        hasError = true;
        errorMessage = 'Haber eklenemedi. Lütfen tekrar deneyin.';
        return false;
      }
    } on TimeoutException catch (e) {
      hasError = true;
      errorMessage = e.toString();
      print('NewsViewModel addNews timeout: $e');
      return false;
    } catch (e) {
      hasError = true;
      errorMessage = 'Beklenmeyen bir hata oluştu: $e';
      print('NewsViewModel addNews error: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateNews(NewsModel model) async {
    try {
      isLoading = true;
      hasError = false;
      errorMessage = '';
      
      final result = await _newsRepository.updateNews(model);
      
      if (result != null) {
        await fetchNews(); // Refresh the list
        return true;
      } else {
        hasError = true;
        errorMessage = 'Haber güncellenemedi. Lütfen tekrar deneyin.';
        return false;
      }
    } on TimeoutException catch (e) {
      hasError = true;
      errorMessage = e.toString();
      print('NewsViewModel updateNews timeout: $e');
      return false;
    } catch (e) {
      hasError = true;
      errorMessage = 'Beklenmeyen bir hata oluştu: $e';
      print('NewsViewModel updateNews error: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteNews(int id) async {
    try {
      isLoading = true;
      hasError = false;
      errorMessage = '';
      
      final result = await _newsRepository.deleteNews(id);
      
      if (result) {
        await fetchNews(); // Refresh the list
        return true;
      } else {
        hasError = true;
        errorMessage = 'Haber silinemedi. Lütfen tekrar deneyin.';
        return false;
      }
    } on TimeoutException catch (e) {
      hasError = true;
      errorMessage = e.toString();
      print('NewsViewModel deleteNews timeout: $e');
      return false;
    } catch (e) {
      hasError = true;
      errorMessage = 'Beklenmeyen bir hata oluştu: $e';
      print('NewsViewModel deleteNews error: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearError() {
    hasError = false;
    errorMessage = '';
  }

  @action
  void retry() {
    fetchNews();
  }
}
