import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/announcements/announcement_repository.dart';
import 'package:smart_city/view/authentication/test/model/announcementmodel/announcement_model.dart';

part 'announcement_view_model.g.dart';

class AnnouncementViewModel = _AnnouncementViewModelBase with _$AnnouncementViewModel;

abstract class _AnnouncementViewModelBase with Store {
  final IAnnouncementRepository _announcementRepository;

  _AnnouncementViewModelBase(this._announcementRepository);

  @observable
  bool isLoading = false;

  @observable
  List<AnnouncementModel>? announcementList;

  @action
  Future<void> fetchAnnouncement() async {
    isLoading = true;
    final announcements = await _announcementRepository.getAnnouncement();
    print("DEBUG announcements: $announcements");
    announcementList = announcements;
    isLoading = false;
  }

  @action
  Future<bool> addAnnouncement(AnnouncementModel model) async {
    isLoading = true;
    final result = await _announcementRepository.addAnnouncement(model);
    await fetchAnnouncement();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> updateAnnouncement(AnnouncementModel model) async {
    isLoading = true;
    final result = await _announcementRepository.updateAnnouncement(model);
    await fetchAnnouncement();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> deleteAnnouncement(int id) async {
    isLoading = true;
    final result = await _announcementRepository.deleteAnnouncement(id);
    await fetchAnnouncement();
    isLoading = false;
    return result;
  }
}
