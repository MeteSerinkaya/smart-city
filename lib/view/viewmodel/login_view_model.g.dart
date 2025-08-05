// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$LoginViewModel on _LoginViewModelBase, Store {
  late final _$nameAtom = Atom(
    name: '_LoginViewModelBase.name',
    context: context,
  );

  @override
  String get name {
    _$nameAtom.reportRead();
    return super.name;
  }

  bool _nameIsInitialized = false;

  @override
  set name(String value) {
    _$nameAtom.reportWrite(value, _nameIsInitialized ? super.name : null, () {
      super.name = value;
      _nameIsInitialized = true;
    });
  }

  late final _$_LoginViewModelBaseActionController = ActionController(
    name: '_LoginViewModelBase',
    context: context,
  );

  @override
  void changeName(String name) {
    final _$actionInfo = _$_LoginViewModelBaseActionController.startAction(
      name: '_LoginViewModelBase.changeName',
    );
    try {
      return super.changeName(name);
    } finally {
      _$_LoginViewModelBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
name: ${name}
    ''';
  }
}
