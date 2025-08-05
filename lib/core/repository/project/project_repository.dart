import 'package:smart_city/view/authentication/test/model/project/project_model.dart';
import 'package:smart_city/core/service/project/project_service.dart';

abstract class IProjectRepository {
  Future<List<ProjectModel>?> getProjects();
  Future<ProjectModel?> addProject(ProjectModel model);
  Future<ProjectModel?> updateProject(ProjectModel model);
  Future<bool> deleteProject(int id);
}

class ProjectRepository extends IProjectRepository {
  final IProjectService _projectService;

  ProjectRepository(this._projectService);

  @override
  Future<List<ProjectModel>?> getProjects() async {
    return await _projectService.fetchProjects();
  }

  @override
  Future<ProjectModel?> addProject(ProjectModel model) async {
    return await _projectService.addProject(model);
  }

  @override
  Future<ProjectModel?> updateProject(ProjectModel model) async {
    return await _projectService.updateProject(model);
  }

  @override
  Future<bool> deleteProject(int id) async {
    return await _projectService.deleteProject(id);
  }
}
