import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/project/project_repository.dart';
import 'package:smart_city/view/authentication/test/model/project/project_model.dart';

part 'project_view_model.g.dart';

class ProjectViewModel = _ProjectViewModelBase with _$ProjectViewModel;

abstract class _ProjectViewModelBase with Store {
  final IProjectRepository _projectRepository;

  _ProjectViewModelBase(this._projectRepository);

  @observable
  bool isLoading = false;

  @observable
  List<ProjectModel>? projectList;

  @action
  Future<void> fetchProjects() async {
    isLoading = true;
    projectList = await _projectRepository.getProjects();
    isLoading = false;
  }

  @action
  Future<bool> addProject(ProjectModel model) async {
    isLoading = true;
    final result = await _projectRepository.addProject(model);
    await fetchProjects();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> updateProject(ProjectModel model) async {
    isLoading = true;
    final result = await _projectRepository.updateProject(model);
    await fetchProjects();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> deleteProject(int id) async {
    isLoading = true;
    final result = await _projectRepository.deleteProject(id);
    await fetchProjects();
    isLoading = false;
    return result;
  }
}
