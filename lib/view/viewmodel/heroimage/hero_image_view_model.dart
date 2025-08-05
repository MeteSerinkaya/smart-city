import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/heroimage/hero_image_repository.dart';
import 'package:smart_city/core/service/heroimage/hero_image_service.dart';
import 'package:smart_city/view/authentication/test/model/heroimagemodel/hero_image_model.dart';

part 'hero_image_view_model.g.dart';

class HeroImageViewModel = _HeroImageViewModelBase with _$HeroImageViewModel;

abstract class _HeroImageViewModelBase with Store {
  final IHeroImageRepository _heroImageRepository;
  final IHeroImageService _heroImageService;

  _HeroImageViewModelBase(this._heroImageRepository, this._heroImageService);

  @observable
  bool isLoading = false;

  @observable
  List<HeroImageModel>? heroImageList;

  @observable
  HeroImageModel? currentImage;

  @observable
  int currentIndex = 0;

  @observable
  String? error;

  @computed
  bool get hasImages => heroImageList != null && heroImageList!.isNotEmpty;

  @action
  Future<void> fetchHeroImages() async {
    isLoading = true;
    error = null;

    try {
      final images = await _heroImageRepository.getHeroImages();
      print('DEBUG fetchHeroImages response: $images');
      heroImageList = images;
      print('DEBUG heroImageList after set: $heroImageList');

      if (heroImageList != null && heroImageList!.isNotEmpty) {
        currentImage = heroImageList!.first;
        currentIndex = 0;
      }
    } catch (e) {
      print('DEBUG fetchHeroImages error: $e');
      error = 'Hero resimleri yüklenirken hata oluştu: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> fetchLatestImage() async {
    isLoading = true;
    error = null;

    try {
      currentImage = await _heroImageRepository.getLatestHeroImage();
      if (currentImage != null) {
        currentIndex = 0;
      }
    } catch (e) {
      error = 'Son hero resmi yüklenirken hata oluştu: $e';
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> addHeroImage(HeroImageModel model) async {
    isLoading = true;
    error = null;

    try {
      final result = await _heroImageRepository.addHeroImage(model);
      await fetchHeroImages();
      isLoading = false;
      return result != null;
    } catch (e) {
      error = 'Hero resmi eklenirken hata oluştu: $e';
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> updateHeroImage(HeroImageModel model) async {
    isLoading = true;
    error = null;

    try {
      final result = await _heroImageRepository.updateHeroImage(model);
      await fetchHeroImages();
      isLoading = false;
      return result != null;
    } catch (e) {
      error = 'Hero resmi güncellenirken hata oluştu: $e';
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> deleteHeroImage(int id) async {
    isLoading = true;
    error = null;

    try {
      final result = await _heroImageRepository.deleteHeroImage(id);
      await fetchHeroImages();
      isLoading = false;
      return result;
    } catch (e) {
      error = 'Hero resmi silinirken hata oluştu: $e';
      isLoading = false;
      return false;
    }
  }

  @action
  Future<bool> uploadImage(dynamic imageFile, String title, String description) async {
    isLoading = true;
    error = null;

    try {
      final uploadedImage = await _heroImageService.uploadImage(imageFile, title, description);

      if (uploadedImage != null) {
        // Immediately refresh the list after successful upload
        await fetchHeroImages();
        isLoading = false;
        return true;
      } else {
        error = 'Resim yüklendi ancak model oluşturulamadı';
        isLoading = false;
        return false;
      }
    } catch (e) {
      error = 'Resim yüklenirken hata oluştu: $e';
      isLoading = false;
      return false;
    }
  }

  @action
  void nextImage() {
    if (heroImageList == null || heroImageList!.isEmpty) return;

    currentIndex = (currentIndex + 1) % heroImageList!.length;
    currentImage = heroImageList![currentIndex];
  }

  @action
  void previousImage() {
    if (heroImageList == null || heroImageList!.isEmpty) return;

    currentIndex = (currentIndex - 1 + heroImageList!.length) % heroImageList!.length;
    currentImage = heroImageList![currentIndex];
  }

  @action
  void goToImage(int index) {
    if (heroImageList == null || index < 0 || index >= heroImageList!.length) return;

    currentIndex = index;
    currentImage = heroImageList![currentIndex];
  }
}
