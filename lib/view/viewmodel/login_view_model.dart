import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:smart_city/core/base/model/base_view_model.dart';

part 'login_view_model.g.dart';

class LoginViewModel = _LoginViewModelBase with _$LoginViewModel;

abstract class _LoginViewModelBase extends BaseViewModel with Store {
  @override
  void setContext(BuildContext context) {
    buildContext = context;
  }

  @override
  void init() {}

  @observable
  late String name;
  @action
  void changeName(String name) {
    this.name = name;
  }
}
