// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$NewsViewModel on _NewsViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_NewsViewModelBase.isLoading',
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

  late final _$hasErrorAtom = Atom(
    name: '_NewsViewModelBase.hasError',
    context: context,
  );

  @override
  bool get hasError {
    _$hasErrorAtom.reportRead();
    return super.hasError;
  }

  @override
  set hasError(bool value) {
    _$hasErrorAtom.reportWrite(value, super.hasError, () {
      super.hasError = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_NewsViewModelBase.errorMessage',
    context: context,
  );

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$newsListAtom = Atom(
    name: '_NewsViewModelBase.newsList',
    context: context,
  );

  @override
  List<NewsModel>? get newsList {
    _$newsListAtom.reportRead();
    return super.newsList;
  }

  @override
  set newsList(List<NewsModel>? value) {
    _$newsListAtom.reportWrite(value, super.newsList, () {
      super.newsList = value;
    });
  }

  late final _$fetchNewsAsyncAction = AsyncAction(
    '_NewsViewModelBase.fetchNews',
    context: context,
  );

  @override
  Future<void> fetchNews() {
    return _$fetchNewsAsyncAction.run(() => super.fetchNews());
  }

  late final _$addNewsAsyncAction = AsyncAction(
    '_NewsViewModelBase.addNews',
    context: context,
  );

  @override
  Future<bool> addNews(NewsModel model) {
    return _$addNewsAsyncAction.run(() => super.addNews(model));
  }

  late final _$updateNewsAsyncAction = AsyncAction(
    '_NewsViewModelBase.updateNews',
    context: context,
  );

  @override
  Future<bool> updateNews(NewsModel model) {
    return _$updateNewsAsyncAction.run(() => super.updateNews(model));
  }

  late final _$deleteNewsAsyncAction = AsyncAction(
    '_NewsViewModelBase.deleteNews',
    context: context,
  );

  @override
  Future<bool> deleteNews(int id) {
    return _$deleteNewsAsyncAction.run(() => super.deleteNews(id));
  }

  late final _$_NewsViewModelBaseActionController = ActionController(
    name: '_NewsViewModelBase',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_NewsViewModelBaseActionController.startAction(
      name: '_NewsViewModelBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_NewsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void retry() {
    final _$actionInfo = _$_NewsViewModelBaseActionController.startAction(
      name: '_NewsViewModelBase.retry',
    );
    try {
      return super.retry();
    } finally {
      _$_NewsViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
hasError: ${hasError},
errorMessage: ${errorMessage},
newsList: ${newsList}
    ''';
  }
}
