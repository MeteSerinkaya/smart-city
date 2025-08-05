import 'package:mobx/mobx.dart';
import 'package:smart_city/core/constants/enums/locale_keys_enum.dart';
import 'package:smart_city/core/init/cache/locale_manager.dart';
import 'package:smart_city/core/repository/auth/auth_repository.dart';
import 'package:smart_city/view/authentication/model/login_request_model.dart';

part 'auth_view_model.g.dart';

class AuthViewModel = _AuthViewModelBase with _$AuthViewModel;

abstract class _AuthViewModelBase with Store {
  final IAuthRepository _authRepository;

  _AuthViewModelBase(this._authRepository);

  @observable
  bool isLoading = false;

  @observable
  String? errorMessage;

  @action
  Future<bool> login(String userName, String password) async {
    print('DEBUG: AuthViewModel.login() called with username: $userName');
    isLoading = true;
    errorMessage = null;

    try {
      final request = LoginRequestModel(username: userName, password: password);
      print('DEBUG: Sending login request to repository');
      final response = await _authRepository.login(request);

      print('DEBUG: Repository response: $response');
      print('DEBUG: Response accessToken: ${response?.accessToken}');
      print('DEBUG: Response role: ${response?.role}');
      print('DEBUG: Response username: ${response?.username}');

      if (response != null && response.accessToken != null) {
        // Token kaydet
        await LocaleManager.instance.setStringValue(PreferencesKeys.TOKEN, response.accessToken!);
        print('DEBUG: Token saved to LocaleManager');

        // Role null geliyorsa username'e göre admin kontrolü yap
        final isAdmin = response.role?.toLowerCase() == 'admin' || response.username?.toLowerCase() == 'admin';
        print('DEBUG: Is admin: $isAdmin (role: ${response.role}, username: ${response.username})');
        LocaleManager.instance.setBoolValue(PreferencesKeys.IS_ADMIN, isAdmin);
        print('DEBUG: Admin status saved to LocaleManager');
        return true;
      } else {
        errorMessage = "Login failed";
        print('DEBUG: Login failed - no response or no token');
        return false;
      }
    } catch (e) {
      errorMessage = e.toString();
      print('DEBUG: Login error: $e');
      return false;
    } finally {
      isLoading = false; // Burada kesin false yapılmalı
      print('DEBUG: Login process completed');
    }
  }
}
