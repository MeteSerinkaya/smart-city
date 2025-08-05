import 'package:smart_city/core/init/network/network_manager.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';

abstract class IAnnouncementService {
  Future<List<AnnouncementModel>?> fetchAnnouncement();
  Future<AnnouncementModel?> addAnnouncement(AnnouncementModel model);
  Future<AnnouncementModel?> updateAnnouncement(AnnouncementModel model);
  Future<bool> deleteAnnouncement(int id);
}

class AnnouncementService extends IAnnouncementService {
  @override
  Future<List<AnnouncementModel>?> fetchAnnouncement() async {
    try {
      final response = await NetworkManager.instance.dioGet('announcements', AnnouncementModel());
      if (response != null && response is List) {
        return response.cast<AnnouncementModel>();
      }
      return null;
    } catch (e) {
      print("AnnouncementService fetchAnnouncement error: $e");
      return null;
    }
  }

  @override
  Future<AnnouncementModel?> addAnnouncement(AnnouncementModel model) async {
    try {
      final data = model.toJson();
      data.remove('id'); // id göndermeyelim
      final response = await NetworkManager.instance.dio.post('announcements', data: data);
      
      if (response.statusCode == 201) {
        return AnnouncementModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("AnnouncementService addAnnouncement error: $e");
      return null;
    }
  }

  @override
  Future<AnnouncementModel?> updateAnnouncement(AnnouncementModel model) async {
    try {
      final response = await NetworkManager.instance.dio.put('announcements/${model.id}', data: model.toJson());
      
      if (response.statusCode == 204) {
        return model; // PUT returns 204 No Content, so return the updated model
      }
      return null;
    } catch (e) {
      print("AnnouncementService updateAnnouncement error: $e");
      return null;
    }
  }

  @override
  Future<bool> deleteAnnouncement(int id) async {
    try {
      final response = await NetworkManager.instance.dio.delete('announcements/$id');
      return response.statusCode == 204;
    } catch (e) {
      print("AnnouncementService deleteAnnouncement error: $e");
      return false;
    }
  }
}
