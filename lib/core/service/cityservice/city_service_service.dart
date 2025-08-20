import 'package:smart_city/core/init/network/network_manager.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';

abstract class ICityServiceService {
  Future<List<CityServiceModel>?> fetchCityServices();
  Future<CityServiceModel?> getCityServiceById(int id);
  Future<CityServiceModel?> addCityService(CityServiceModel model);
  Future<CityServiceModel?> updateCityService(CityServiceModel model);
  Future<bool> deleteCityService(int id);
}

class CityServiceService extends ICityServiceService {
  @override
  Future<List<CityServiceModel>?> fetchCityServices() async {
    try {
      final response = await NetworkManager.instance.dioGet('cityservices', CityServiceModel());
      if (response != null && response is List) {
        return response.cast<CityServiceModel>();
      }
      return null;
    } catch (e) {
      print("CityServiceService fetchCityServices error: $e");
      return null;
    }
  }

  @override
  Future<CityServiceModel?> getCityServiceById(int id) async {
    try {
      final response = await NetworkManager.instance.dioGet('cityservices/$id', CityServiceModel());
      if (response != null && response is CityServiceModel) {
        return response;
      }
      return null;
    } catch (e) {
      print("CityServiceService getCityServiceById error: $e");
      return null;
    }
  }

  @override
  Future<CityServiceModel?> addCityService(CityServiceModel model) async {
    try {
      final data = model.toJson();
      data.remove('id');
      final response = await NetworkManager.instance.dio.post('cityservices', data: data);
      
      if (response.statusCode == 201) {
        return CityServiceModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("CityServiceService addCityService error: $e");
      return null;
    }
  }

  @override
  Future<CityServiceModel?> updateCityService(CityServiceModel model) async {
    try {
      final response = await NetworkManager.instance.dio.put('cityservices/${model.id}', data: model.toJson());
      
      if (response.statusCode == 204) {
        return model; // PUT returns 204 No Content, so return the updated model
      }
      return null;
    } catch (e) {
      print("CityServiceService updateCityService error: $e");
      return null;
    }
  }

  @override
  Future<bool> deleteCityService(int id) async {
    try {
      final response = await NetworkManager.instance.dio.delete('cityservices/$id');
      return response.statusCode == 204;
    } catch (e) {
      print("CityServiceService deleteCityService error: $e");
      return false;
    }
  }
}
