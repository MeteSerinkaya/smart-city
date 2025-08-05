import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/search/search_repository.dart';
import 'package:smart_city/view/authentication/test/model/searchmodel/search_model.dart';

part 'search_view_model.g.dart';

class SearchViewModel = _SearchViewModelBase with _$SearchViewModel;

abstract class _SearchViewModelBase with Store {
  final ISearchRepository _searchRepository;

  _SearchViewModelBase(this._searchRepository);

  @observable
  bool isLoading = false;

  @observable
  List<SearchModel>? searchResults;

  @observable
  String currentQuery = '';

  @observable
  bool isSearchActive = false;

  @action
  Future<void> search(String query) async {
    if (query.trim().isEmpty) {
      searchResults = null;
      currentQuery = '';
      isSearchActive = false;
      return;
    }

    isLoading = true;
    currentQuery = query;
    isSearchActive = true;
    
    try {
      searchResults = await _searchRepository.searchAll(query);
    } catch (e) {
      print("SearchViewModel search error: $e");
      searchResults = null;
    } finally {
      isLoading = false;
    }
  }

  @action
  void clearSearch() {
    searchResults = null;
    currentQuery = '';
    isSearchActive = false;
  }

  @action
  void setSearchActive(bool active) {
    isSearchActive = active;
  }

  @computed
  bool get hasResults => searchResults != null && searchResults!.isNotEmpty;

  @computed
  List<SearchModel> get newsResults => searchResults?.where((result) => result.type == 'news').toList() ?? [];

  @computed
  List<SearchModel> get announcementResults => searchResults?.where((result) => result.type == 'announcement').toList() ?? [];

  @computed
  List<SearchModel> get projectResults => searchResults?.where((result) => result.type == 'project').toList() ?? [];

  @computed
  List<SearchModel> get cityServiceResults => searchResults?.where((result) => result.type == 'city_service').toList() ?? [];

  @computed
  List<SearchModel> get eventResults => searchResults?.where((result) => result.type == 'event').toList() ?? [];
} 