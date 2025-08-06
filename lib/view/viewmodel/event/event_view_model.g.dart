// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$EventViewModel on _EventViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_EventViewModelBase.isLoading',
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

  late final _$eventListAtom = Atom(
    name: '_EventViewModelBase.eventList',
    context: context,
  );

  @override
  List<EventModel>? get eventList {
    _$eventListAtom.reportRead();
    return super.eventList;
  }

  @override
  set eventList(List<EventModel>? value) {
    _$eventListAtom.reportWrite(value, super.eventList, () {
      super.eventList = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_EventViewModelBase.errorMessage',
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
    name: '_EventViewModelBase.hasError',
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

  late final _$fetchEventsAsyncAction = AsyncAction(
    '_EventViewModelBase.fetchEvents',
    context: context,
  );

  @override
  Future<void> fetchEvents() {
    return _$fetchEventsAsyncAction.run(() => super.fetchEvents());
  }

  late final _$retryFetchEventsAsyncAction = AsyncAction(
    '_EventViewModelBase.retryFetchEvents',
    context: context,
  );

  @override
  Future<void> retryFetchEvents() {
    return _$retryFetchEventsAsyncAction.run(() => super.retryFetchEvents());
  }

  late final _$addEventAsyncAction = AsyncAction(
    '_EventViewModelBase.addEvent',
    context: context,
  );

  @override
  Future<bool> addEvent(EventModel model) {
    return _$addEventAsyncAction.run(() => super.addEvent(model));
  }

  late final _$updateEventAsyncAction = AsyncAction(
    '_EventViewModelBase.updateEvent',
    context: context,
  );

  @override
  Future<bool> updateEvent(EventModel model) {
    return _$updateEventAsyncAction.run(() => super.updateEvent(model));
  }

  late final _$deleteEventAsyncAction = AsyncAction(
    '_EventViewModelBase.deleteEvent',
    context: context,
  );

  @override
  Future<bool> deleteEvent(int id) {
    return _$deleteEventAsyncAction.run(() => super.deleteEvent(id));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
eventList: ${eventList},
errorMessage: ${errorMessage},
hasError: ${hasError}
    ''';
  }
}
