import 'package:smart_city/core/service/heroimage/hero_image_service.dart';
import 'package:smart_city/view/authentication/test/model/heroimagemodel/hero_image_model.dart';

abstract class IHeroImageRepository {
  Future<List<HeroImageModel>?> getHeroImages();
  Future<HeroImageModel?> addHeroImage(HeroImageModel model);
  Future<HeroImageModel?> updateHeroImage(HeroImageModel model);
  Future<bool> deleteHeroImage(int id);
  Future<HeroImageModel?> getLatestHeroImage();
  Future<HeroImageModel?> getHeroImageById(int id);
}

class HeroImageRepository extends IHeroImageRepository {
  final IHeroImageService _heroImageService;

  HeroImageRepository(this._heroImageService);

  @override
  Future<List<HeroImageModel>?> getHeroImages() async {
    return await _heroImageService.fetchHeroImages();
  }

  @override
  Future<HeroImageModel?> addHeroImage(HeroImageModel model) async {
    return await _heroImageService.addHeroImage(model);
  }

  @override
  Future<HeroImageModel?> updateHeroImage(HeroImageModel model) async {
    return await _heroImageService.updateHeroImage(model);
  }

  @override
  Future<bool> deleteHeroImage(int id) async {
    return await _heroImageService.deleteHeroImage(id);
  }

  @override
  Future<HeroImageModel?> getLatestHeroImage() async {
    return await _heroImageService.getLatestHeroImage();
  }

  @override
  Future<HeroImageModel?> getHeroImageById(int id) async {
    return await _heroImageService.getHeroImageById(id);
  }
} 