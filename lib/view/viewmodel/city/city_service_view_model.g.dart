// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_service_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CityServiceViewModel on _CityServiceViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_CityServiceViewModelBase.isLoading',
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

  late final _$cityServiceListAtom = Atom(
    name: '_CityServiceViewModelBase.cityServiceList',
    context: context,
  );

  @override
  List<CityServiceModel>? get cityServiceList {
    _$cityServiceListAtom.reportRead();
    return super.cityServiceList;
  }

  @override
  set cityServiceList(List<CityServiceModel>? value) {
    _$cityServiceListAtom.reportWrite(value, super.cityServiceList, () {
      super.cityServiceList = value;
    });
  }

  late final _$fetchCityServiceAsyncAction = AsyncAction(
    '_CityServiceViewModelBase.fetchCityService',
    context: context,
  );

  @override
  Future<void> fetchCityService() {
    return _$fetchCityServiceAsyncAction.run(() => super.fetchCityService());
  }

  late final _$addCityServiceAsyncAction = AsyncAction(
    '_CityServiceViewModelBase.addCityService',
    context: context,
  );

  @override
  Future<bool> addCityService(CityServiceModel model) {
    return _$addCityServiceAsyncAction.run(() => super.addCityService(model));
  }

  late final _$updateCityServiceAsyncAction = AsyncAction(
    '_CityServiceViewModelBase.updateCityService',
    context: context,
  );

  @override
  Future<bool> updateCityService(CityServiceModel model) {
    return _$updateCityServiceAsyncAction.run(
      () => super.updateCityService(model),
    );
  }

  late final _$deleteCityServiceAsyncAction = AsyncAction(
    '_CityServiceViewModelBase.deleteCityService',
    context: context,
  );

  @override
  Future<bool> deleteCityService(int id) {
    return _$deleteCityServiceAsyncAction.run(
      () => super.deleteCityService(id),
    );
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
cityServiceList: ${cityServiceList}
    ''';
  }
}
