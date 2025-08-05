// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SearchViewModel on _SearchViewModelBase, Store {
  Computed<bool>? _$hasResultsComputed;

  @override
  bool get hasResults => (_$hasResultsComputed ??= Computed<bool>(
    () => super.hasResults,
    name: '_SearchViewModelBase.hasResults',
  )).value;
  Computed<List<SearchModel>>? _$newsResultsComputed;

  @override
  List<SearchModel> get newsResults =>
      (_$newsResultsComputed ??= Computed<List<SearchModel>>(
        () => super.newsResults,
        name: '_SearchViewModelBase.newsResults',
      )).value;
  Computed<List<SearchModel>>? _$announcementResultsComputed;

  @override
  List<SearchModel> get announcementResults =>
      (_$announcementResultsComputed ??= Computed<List<SearchModel>>(
        () => super.announcementResults,
        name: '_SearchViewModelBase.announcementResults',
      )).value;
  Computed<List<SearchModel>>? _$projectResultsComputed;

  @override
  List<SearchModel> get projectResults =>
      (_$projectResultsComputed ??= Computed<List<SearchModel>>(
        () => super.projectResults,
        name: '_SearchViewModelBase.projectResults',
      )).value;
  Computed<List<SearchModel>>? _$cityServiceResultsComputed;

  @override
  List<SearchModel> get cityServiceResults =>
      (_$cityServiceResultsComputed ??= Computed<List<SearchModel>>(
        () => super.cityServiceResults,
        name: '_SearchViewModelBase.cityServiceResults',
      )).value;

  late final _$isLoadingAtom = Atom(
    name: '_SearchViewModelBase.isLoading',
    context: context,
  );

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$searchResultsAtom = Atom(
    name: '_SearchViewModelBase.searchResults',
    context: context,
  );

  @override
  List<SearchModel>? get searchResults {
    _$searchResultsAtom.reportRead();
    return super.searchResults;
  }

  @override
  set searchResults(List<SearchModel>? value) {
    _$searchResultsAtom.reportWrite(value, super.searchResults, () {
      super.searchResults = value;
    });
  }

  late final _$currentQueryAtom = Atom(
    name: '_SearchViewModelBase.currentQuery',
    context: context,
  );

  @override
  String get currentQuery {
    _$currentQueryAtom.reportRead();
    return super.currentQuery;
  }

  @override
  set currentQuery(String value) {
    _$currentQueryAtom.reportWrite(value, super.currentQuery, () {
      super.currentQuery = value;
    });
  }

  late final _$isSearchActiveAtom = Atom(
    name: '_SearchViewModelBase.isSearchActive',
    context: context,
  );

  @override
  bool get isSearchActive {
    _$isSearchActiveAtom.reportRead();
    return super.isSearchActive;
  }

  @override
  set isSearchActive(bool value) {
    _$isSearchActiveAtom.reportWrite(value, super.isSearchActive, () {
      super.isSearchActive = value;
    });
  }

  late final _$searchAsyncAction = AsyncAction(
    '_SearchViewModelBase.search',
    context: context,
  );

  @override
  Future<void> search(String query) {
    return _$searchAsyncAction.run(() => super.search(query));
  }

  late final _$_SearchViewModelBaseActionController = ActionController(
    name: '_SearchViewModelBase',
    context: context,
  );

  @override
  void clearSearch() {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
      name: '_SearchViewModelBase.clearSearch',
    );
    try {
      return super.clearSearch();
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setSearchActive(bool active) {
    final _$actionInfo = _$_SearchViewModelBaseActionController.startAction(
      name: '_SearchViewModelBase.setSearchActive',
    );
    try {
      return super.setSearchActive(active);
    } finally {
      _$_SearchViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
searchResults: ${searchResults},
currentQuery: ${currentQuery},
isSearchActive: ${isSearchActive},
hasResults: ${hasResults},
newsResults: ${newsResults},
announcementResults: ${announcementResults},
projectResults: ${projectResults},
cityServiceResults: ${cityServiceResults}
    ''';
  }
}
