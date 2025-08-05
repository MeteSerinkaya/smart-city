import 'package:smart_city/core/init/network/network_manager.dart';
import 'package:smart_city/view/authentication/model/login_request_model.dart';
import 'package:smart_city/view/authentication/model/login_response_model.dart';

abstract class IAuthService {
  Future<LoginResponseModel?> login(LoginRequestModel request);
}

class AuthService extends IAuthService {
  @override
  Future<LoginResponseModel?> login(LoginRequestModel loginRequest) async {
    try {
      final response = await NetworkManager.instance.dio.post('auth/login', data: loginRequest.toJson());
      
      if (response.statusCode == 200) {
        return LoginResponseModel.fromJson(response.data);
      } else if (response.statusCode == 401) {
        throw Exception("Kullanıcı adı veya şifre hatalı");
      } else {
        throw Exception("Giriş başarısız: ${response.statusCode}");
      }
    } catch (e) {
      print("AuthService login error: $e");
      rethrow;
    }
  }
}
