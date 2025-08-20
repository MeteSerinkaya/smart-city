// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AdminUserViewModel on _AdminUserViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_AdminUserViewModelBase.isLoading',
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

  late final _$adminUserListAtom = Atom(
    name: '_AdminUserViewModelBase.adminUserList',
    context: context,
  );

  @override
  List<AdminUserModel>? get adminUserList {
    _$adminUserListAtom.reportRead();
    return super.adminUserList;
  }

  @override
  set adminUserList(List<AdminUserModel>? value) {
    _$adminUserListAtom.reportWrite(value, super.adminUserList, () {
      super.adminUserList = value;
    });
  }

  late final _$errorMessageAtom = Atom(
    name: '_AdminUserViewModelBase.errorMessage',
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
    name: '_AdminUserViewModelBase.hasError',
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

  late final _$fetchAdminUsersAsyncAction = AsyncAction(
    '_AdminUserViewModelBase.fetchAdminUsers',
    context: context,
  );

  @override
  Future<void> fetchAdminUsers() {
    return _$fetchAdminUsersAsyncAction.run(() => super.fetchAdminUsers());
  }

  late final _$retryFetchAdminUsersAsyncAction = AsyncAction(
    '_AdminUserViewModelBase.retryFetchAdminUsers',
    context: context,
  );

  @override
  Future<void> retryFetchAdminUsers() {
    return _$retryFetchAdminUsersAsyncAction.run(
      () => super.retryFetchAdminUsers(),
    );
  }

  late final _$createAdminUserAsyncAction = AsyncAction(
    '_AdminUserViewModelBase.createAdminUser',
    context: context,
  );

  @override
  Future<bool> createAdminUser(CreateAdminUserModel model) {
    return _$createAdminUserAsyncAction.run(() => super.createAdminUser(model));
  }

  late final _$updateAdminUserAsyncAction = AsyncAction(
    '_AdminUserViewModelBase.updateAdminUser',
    context: context,
  );

  @override
  Future<bool> updateAdminUser(int id, CreateAdminUserModel model) {
    return _$updateAdminUserAsyncAction.run(
      () => super.updateAdminUser(id, model),
    );
  }

  late final _$deleteAdminUserAsyncAction = AsyncAction(
    '_AdminUserViewModelBase.deleteAdminUser',
    context: context,
  );

  @override
  Future<bool> deleteAdminUser(int id) {
    return _$deleteAdminUserAsyncAction.run(() => super.deleteAdminUser(id));
  }

  late final _$_AdminUserViewModelBaseActionController = ActionController(
    name: '_AdminUserViewModelBase',
    context: context,
  );

  @override
  void clearError() {
    final _$actionInfo = _$_AdminUserViewModelBaseActionController.startAction(
      name: '_AdminUserViewModelBase.clearError',
    );
    try {
      return super.clearError();
    } finally {
      _$_AdminUserViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
adminUserList: ${adminUserList},
errorMessage: ${errorMessage},
hasError: ${hasError}
    ''';
  }
}
