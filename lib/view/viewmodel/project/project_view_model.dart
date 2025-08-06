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
      if (result != null && result.isNotEmpty) {
        projectList = result;
      } else {
        // API yanıt vermezse veya boş data gelirse hemen boş state'e geç
        projectList = [];
        hasError = false; // Error state gösterme, boş state göster
        errorMessage = null;
      }
    } catch (e) {
      // Hata durumunda da boş state'e geç, error state gösterme
      hasError = false;
      errorMessage = null;
      projectList = [];
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
      return false;
    } finally {
      isLoading = false;
    }
  }
}
