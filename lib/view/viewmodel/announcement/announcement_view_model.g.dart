// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnnouncementViewModel on _AnnouncementViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_AnnouncementViewModelBase.isLoading',
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

  late final _$announcementListAtom = Atom(
    name: '_AnnouncementViewModelBase.announcementList',
    context: context,
  );

  @override
  List<AnnouncementModel>? get announcementList {
    _$announcementListAtom.reportRead();
    return super.announcementList;
  }

  @override
  set announcementList(List<AnnouncementModel>? value) {
    _$announcementListAtom.reportWrite(value, super.announcementList, () {
      super.announcementList = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AnnouncementViewModelBase.errorMessage',
    context: context,
  );

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$hasErrorAtom = Atom(
    name: '_AnnouncementViewModelBase.hasError',
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

  late final _$fetchAnnouncementAsyncAction = AsyncAction(
    '_AnnouncementViewModelBase.fetchAnnouncement',
    context: context,
  );

  @override
  Future<void> fetchAnnouncement() {
    return _$fetchAnnouncementAsyncAction.run(() => super.fetchAnnouncement());
  }

  late final _$retryFetchAnnouncementAsyncAction = AsyncAction(
    '_AnnouncementViewModelBase.retryFetchAnnouncement',
    context: context,
  );

  @override
  Future<void> retryFetchAnnouncement() {
    return _$retryFetchAnnouncementAsyncAction.run(
      () => super.retryFetchAnnouncement(),
    );
  }

  late final _$addAnnouncementAsyncAction = AsyncAction(
    '_AnnouncementViewModelBase.addAnnouncement',
    context: context,
  );

  @override
  Future<bool> addAnnouncement(AnnouncementModel model) {
    return _$addAnnouncementAsyncAction.run(() => super.addAnnouncement(model));
  }

  late final _$updateAnnouncementAsyncAction = AsyncAction(
    '_AnnouncementViewModelBase.updateAnnouncement',
    context: context,
  );

  @override
  Future<bool> updateAnnouncement(AnnouncementModel model) {
    return _$updateAnnouncementAsyncAction.run(
      () => super.updateAnnouncement(model),
    );
  }

  late final _$deleteAnnouncementAsyncAction = AsyncAction(
    '_AnnouncementViewModelBase.deleteAnnouncement',
    context: context,
  );

  @override
  Future<bool> deleteAnnouncement(int id) {
    return _$deleteAnnouncementAsyncAction.run(
      () => super.deleteAnnouncement(id),
    );
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
announcementList: ${announcementList},
errorMessage: ${errorMessage},
hasError: ${hasError}
    ''';
  }
}
