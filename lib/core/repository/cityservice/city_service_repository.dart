import 'package:smart_city/core/service/cityservice/city_service_service.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';

abstract class ICityServiceRepository {
  Future<List<CityServiceModel>?> getCityServices();
  Future<CityServiceModel?> getCityServiceById(int id);
  Future<CityServiceModel?> addCityService(CityServiceModel model);
  Future<CityServiceModel?> updateCityService(CityServiceModel model);
  Future<bool> deleteCityService(int id);
}

class CityServiceRepository extends ICityServiceRepository {
  final ICityServiceService _cityServiceService;

  CityServiceRepository(this._cityServiceService);

  @override
  Future<List<CityServiceModel>?> getCityServices() async {
    return await _cityServiceService.fetchCityServices();
  }

  @override
  Future<CityServiceModel?> getCityServiceById(int id) async {
    return await _cityServiceService.getCityServiceById(id);
  }

  @override
  Future<CityServiceModel?> addCityService(CityServiceModel model) async {
    return await _cityServiceService.addCityService(model);
  }

  @override
  Future<CityServiceModel?> updateCityService(CityServiceModel model) async {
    return await _cityServiceService.updateCityService(model);
  }

  @override
  Future<bool> deleteCityService(int id) async {
    return await _cityServiceService.deleteCityService(id);
  }
}
