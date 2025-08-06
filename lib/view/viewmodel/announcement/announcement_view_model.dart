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

  @observable
  String? errorMessage;

  @observable
  bool hasError = false;

  @action
  Future<void> fetchAnnouncement() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final announcements = await _announcementRepository.getAnnouncement();
      print("DEBUG announcements: $announcements");
      // Hemen boş state'e geç, hiç bekleme yok
      if (announcements != null && announcements.isNotEmpty) {
        announcementList = announcements;
      } else {
        announcementList = [];
        hasError = false;
        errorMessage = null;
      }
    } catch (e) {
      // Hata durumunda da hemen boş state'e geç
      hasError = false;
      errorMessage = null;
      announcementList = [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> retryFetchAnnouncement() async {
    await fetchAnnouncement();
  }

  @action
  Future<bool> addAnnouncement(AnnouncementModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _announcementRepository.addAnnouncement(model);
      if (result != null) {
        await fetchAnnouncement();
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
  Future<bool> updateAnnouncement(AnnouncementModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _announcementRepository.updateAnnouncement(model);
      if (result != null) {
        await fetchAnnouncement();
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
  Future<bool> deleteAnnouncement(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _announcementRepository.deleteAnnouncement(id);
      if (result) {
        await fetchAnnouncement();
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
