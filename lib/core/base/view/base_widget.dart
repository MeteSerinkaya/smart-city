// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

class BaseView<T extends Store> extends StatefulWidget {
  final Widget Function(BuildContext context, T value) onPageBuilder;
  final T viewModel;
  final Function(T model) onModelReady;
  final VoidCallback onDispose;
  const BaseView({
    super.key,
    required this.viewModel,
    required this.onModelReady,
    required this.onPageBuilder,
    required this.onDispose,
  });

  @override
  State<BaseView> createState() => _BaseViewState();
}

class _BaseViewState extends State<BaseView> {
  @override
  void initState() {
    super.initState();
    widget.onModelReady(widget.viewModel);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    widget.onDispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.onPageBuilder(context, widget.viewModel);
  }
}
