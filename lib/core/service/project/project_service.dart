import 'package:smart_city/view/authentication/test/model/project/project_model.dart';
import 'package:smart_city/core/init/network/network_manager.dart';

abstract class IProjectService {
  Future<List<ProjectModel>?> fetchProjects();
  Future<ProjectModel?> getProjectById(int id);
  Future<ProjectModel?> addProject(ProjectModel model);
  Future<ProjectModel?> updateProject(ProjectModel model);
  Future<bool> deleteProject(int id);
}

class ProjectService extends IProjectService {
  @override
  Future<List<ProjectModel>?> fetchProjects() async {
    try {
      final response = await NetworkManager.instance.dioGet('projects', ProjectModel());
      if (response != null && response is List) {
        return response.cast<ProjectModel>();
      }
      return null;
    } catch (e) {
      print("ProjectService fetchProjects error: $e");
      return null;
    }
  }

  @override
  Future<ProjectModel?> getProjectById(int id) async {
    try {
      final response = await NetworkManager.instance.dioGet('projects/$id', ProjectModel());
      if (response != null && response is ProjectModel) {
        return response;
      }
      return null;
    } catch (e) {
      print("ProjectService getProjectById error: $e");
      return null;
    }
  }

  @override
  Future<ProjectModel?> addProject(ProjectModel model) async {
    try {
      final data = model.toJson();
      data.remove('id');
      // Remove null values to avoid backend validation issues
      data.removeWhere((key, value) => value == null);
      print("ProjectService addProject sending data: $data");
      final response = await NetworkManager.instance.dio.post('projects', data: data);
      if (response.statusCode == 201) {
        return ProjectModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("ProjectService addProject error: $e");
      return null;
    }
  }

  @override
  Future<ProjectModel?> updateProject(ProjectModel model) async {
    try {
      final data = model.toJson();
      // Remove null values to avoid backend validation issues
      data.removeWhere((key, value) => value == null);
      print("ProjectService updateProject sending data: $data");
      final response = await NetworkManager.instance.dio.put('projects/${model.id}', data: data);
      if (response.statusCode == 204) {
        return model;
      }
      return null;
    } catch (e) {
      print("ProjectService updateProject error: $e");
      return null;
    }
  }

  @override
  Future<bool> deleteProject(int id) async {
    try {
      final response = await NetworkManager.instance.dio.delete('projects/$id');
      return response.statusCode == 204;
    } catch (e) {
      print("ProjectService deleteProject error: $e");
      return false;
    }
  }
}
