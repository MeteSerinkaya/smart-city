import 'package:flutter/material.dart';

abstract class BaseViewModel {
  late BuildContext buildContext;

  void setContext(BuildContext context) {
    buildContext = context;
  }

  void init();
}
