import 'package:smart_city/core/service/announcements/announcement_service.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';

abstract class IAnnouncementRepository {
  Future<List<AnnouncementModel>?> getAnnouncement();
  Future<AnnouncementModel?> addAnnouncement(AnnouncementModel model);
  Future<AnnouncementModel?> updateAnnouncement(AnnouncementModel model);
  Future<bool> deleteAnnouncement(int id);
}

class AnnouncementRepository extends IAnnouncementRepository {
  final IAnnouncementService _announcementService;

  AnnouncementRepository(this._announcementService);

  @override
  Future<List<AnnouncementModel>?> getAnnouncement() async {
    return await _announcementService.fetchAnnouncement();
  }

  @override
  Future<AnnouncementModel?> addAnnouncement(AnnouncementModel model) async {
    return await _announcementService.addAnnouncement(model);
  }

  @override
  Future<AnnouncementModel?> updateAnnouncement(AnnouncementModel model) async {
    return await _announcementService.updateAnnouncement(model);
  }

  @override
  Future<bool> deleteAnnouncement(int id) async {
    return await _announcementService.deleteAnnouncement(id);
  }
}
