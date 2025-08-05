// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'project_view_model.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ProjectViewModel on _ProjectViewModelBase, Store {
  late final _$isLoadingAtom = Atom(
    name: '_ProjectViewModelBase.isLoading',
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

  late final _$projectListAtom = Atom(
    name: '_ProjectViewModelBase.projectList',
    context: context,
  );

  @override
  List<ProjectModel>? get projectList {
    _$projectListAtom.reportRead();
    return super.projectList;
  }

  @override
  set projectList(List<ProjectModel>? value) {
    _$projectListAtom.reportWrite(value, super.projectList, () {
      super.projectList = value;
    });
  }

  late final _$fetchProjectsAsyncAction = AsyncAction(
    '_ProjectViewModelBase.fetchProjects',
    context: context,
  );

  @override
  Future<void> fetchProjects() {
    return _$fetchProjectsAsyncAction.run(() => super.fetchProjects());
  }

  late final _$addProjectAsyncAction = AsyncAction(
    '_ProjectViewModelBase.addProject',
    context: context,
  );

  @override
  Future<bool> addProject(ProjectModel model) {
    return _$addProjectAsyncAction.run(() => super.addProject(model));
  }

  late final _$updateProjectAsyncAction = AsyncAction(
    '_ProjectViewModelBase.updateProject',
    context: context,
  );

  @override
  Future<bool> updateProject(ProjectModel model) {
    return _$updateProjectAsyncAction.run(() => super.updateProject(model));
  }

  late final _$deleteProjectAsyncAction = AsyncAction(
    '_ProjectViewModelBase.deleteProject',
    context: context,
  );

  @override
  Future<bool> deleteProject(int id) {
    return _$deleteProjectAsyncAction.run(() => super.deleteProject(id));
  }

  @override
  String toString() {
    return '''
isLoading: ${isLoading},
projectList: ${projectList}
    ''';
  }
}
