import 'package:mobx/mobx.dart';
import 'package:smart_city/core/service/admin_user/admin_user_service.dart';
import 'package:smart_city/view/authentication/test/model/adminuser/admin_user_model.dart';
import 'package:smart_city/view/authentication/test/model/adminuser/create_admin_user_model.dart';

part 'admin_user_view_model.g.dart';

class AdminUserViewModel = _AdminUserViewModelBase with _$AdminUserViewModel;

abstract class _AdminUserViewModelBase with Store {
  final AdminUserService _adminUserService = AdminUserService();

  @observable
  bool isLoading = false;

  @observable
  List<AdminUserModel>? adminUserList;

  @observable
  String? errorMessage;

  @observable
  bool hasError = false;

  @action
  Future<void> fetchAdminUsers() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;

    try {
      final result = await _adminUserService.getAdminUsers();

      if (result.isNotEmpty) {
        adminUserList = result;
      } else {
        adminUserList = [];
        hasError = false;
        errorMessage = null;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      adminUserList = [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> retryFetchAdminUsers() async {
    await fetchAdminUsers();
  }

  @action
  Future<bool> createAdminUser(CreateAdminUserModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;

    try {
      final result = await _adminUserService.createAdminUser(model);
      if (result) {
        await fetchAdminUsers();
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
  Future<bool> updateAdminUser(int id, CreateAdminUserModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;

    try {
      final result = await _adminUserService.updateAdminUser(id, model);
      if (result) {
        await fetchAdminUsers();
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
  Future<bool> deleteAdminUser(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;

    try {
      final result = await _adminUserService.deleteAdminUser(id);
      if (result) {
        await fetchAdminUsers();
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
  void clearError() {
    hasError = false;
    errorMessage = null;
  }
}
