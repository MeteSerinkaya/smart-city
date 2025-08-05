import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/cityservice/city_service_repository.dart';
import 'package:smart_city/view/authentication/test/model/citymodel/city_service_model.dart';

part 'city_service_view_model.g.dart';

class CityServiceViewModel = _CityServiceViewModelBase with _$CityServiceViewModel;

abstract class _CityServiceViewModelBase with Store {
  final ICityServiceRepository _cityServiceRepository;

  _CityServiceViewModelBase(this._cityServiceRepository);

  @observable
  bool isLoading = false;

  @observable
  List<CityServiceModel>? cityServiceList;

  @action
  Future<void> fetchCityService() async {
    isLoading = true;
    cityServiceList = await _cityServiceRepository.getCityServices();
    isLoading = false;
  }

  @action
  Future<bool> addCityService(CityServiceModel model) async {
    isLoading = true;
    final result = await _cityServiceRepository.addCityService(model);
    await fetchCityService();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> updateCityService(CityServiceModel model) async {
    isLoading = true;
    final result = await _cityServiceRepository.updateCityService(model);
    await fetchCityService();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> deleteCityService(int id) async {
    isLoading = true;
    final result = await _cityServiceRepository.deleteCityService(id);
    await fetchCityService();
    isLoading = false;
    return result;
  }
}
