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

  @observable
  ProjectModel? singleProject;

  @observable
  String? errorMessage;

  @observable
  bool hasError = false;

  @action
  Future<void> fetchProjects() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _projectRepository.getProjects();
      // Hemen boş state'e geç, hiç bekleme yok
      if (result != null && result.isNotEmpty) {
        projectList = result;
      } else {
        projectList = [];
        hasError = false;
        errorMessage = null;
      }
    } catch (e) {
      // Hata durumunda da hemen boş state'e geç
      hasError = false;
      errorMessage = null;
      projectList = [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> getProjectById(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    try {
      final project = await _projectRepository.getProjectById(id);
      if (project != null) {
        singleProject = project;
      } else {
        hasError = true;
        errorMessage = 'Proje bulunamadı';
      }
    } catch (e) {
      hasError = true;
      errorMessage = 'Proje yüklenirken hata oluştu';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> retryFetchProjects() async {
    await fetchProjects();
  }

  @action
  Future<bool> addProject(ProjectModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _projectRepository.addProject(model);
      if (result != null) {
        await fetchProjects();
        return true;
      } else {
        hasError = false;
        return false;
      }
    } catch (e) {
      hasError = false;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateProject(ProjectModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _projectRepository.updateProject(model);
      if (result != null) {
        await fetchProjects();
        return true;
      } else {
        hasError = false;
        return false;
      }
    } catch (e) {
      hasError = false;
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteProject(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _projectRepository.deleteProject(id);
      if (result) {
        await fetchProjects();
        return true;
      } else {
        hasError = false;
        return false;
      }
    } catch (e) {
      hasError = false;
      return false;
    } finally {
      isLoading = false;
    }
  }
}
