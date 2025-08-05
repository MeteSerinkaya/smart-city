import 'package:flutter/material.dart';
import 'package:smart_city/core/base/view/base_widget.dart';
import 'package:smart_city/view/viewmodel/login_view_model.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView<LoginViewModel>(
      viewModel: LoginViewModel(),
      onModelReady: (model) {
        model.setContext(context);
      },
      onPageBuilder: (BuildContext context, LoginViewModel value) => Scaffold(),
      onDispose: () {},
    );
  }
}
