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

  @observable
  CityServiceModel? singleCityService;

  @observable
  String? errorMessage;

  @observable
  bool hasError = false;

  @action
  Future<void> fetchCityService() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _cityServiceRepository.getCityServices();
      // Hemen boş state'e geç, hiç bekleme yok
      if (result != null && result.isNotEmpty) {
        cityServiceList = result;
      } else {
        cityServiceList = [];
        hasError = false;
        errorMessage = null;
      }
    } catch (e) {
      // Hata durumunda da hemen boş state'e geç
      hasError = false;
      errorMessage = null;
      cityServiceList = [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> getCityServiceById(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    try {
      final service = await _cityServiceRepository.getCityServiceById(id);
      if (service != null) {
        singleCityService = service;
      } else {
        hasError = true;
        errorMessage = 'Hizmet bulunamadı';
      }
    } catch (e) {
      hasError = true;
      errorMessage = 'Hizmet yüklenirken hata oluştu';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> retryFetchCityService() async {
    await fetchCityService();
  }

  @action
  Future<bool> addCityService(CityServiceModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _cityServiceRepository.addCityService(model);
      if (result != null) {
        await fetchCityService();
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
  Future<bool> updateCityService(CityServiceModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _cityServiceRepository.updateCityService(model);
      if (result != null) {
        await fetchCityService();
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
  Future<bool> deleteCityService(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _cityServiceRepository.deleteCityService(id);
      if (result) {
        await fetchCityService();
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
