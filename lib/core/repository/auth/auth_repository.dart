import 'package:smart_city/core/service/auth/auth_service.dart';
import 'package:smart_city/view/authentication/model/login_request_model.dart';
import 'package:smart_city/view/authentication/model/login_response_model.dart';

abstract class IAuthRepository {
  Future<LoginResponseModel?> login(LoginRequestModel request);
}

class AuthRepository extends IAuthRepository {
  final IAuthService _authService;

  AuthRepository(this._authService);

  @override
  Future<LoginResponseModel?> login(LoginRequestModel request) async {
    return await _authService.login(request);
  }
}
