import 'package:mobx/mobx.dart';
import 'package:smart_city/core/repository/event/event_repository.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';

part 'event_view_model.g.dart';

class EventViewModel = _EventViewModelBase with _$EventViewModel;

abstract class _EventViewModelBase with Store {
  final IEventRepository _eventRepository;

  _EventViewModelBase(this._eventRepository);

  @observable
  bool isLoading = false;

  @observable
  List<EventModel>? eventList;

  @observable
  String? errorMessage;

  @observable
  bool hasError = false;

  @action
  Future<void> fetchEvents() async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final events = await _eventRepository.getEvents();
      print('DEBUG fetchEvents response: $events');
      if (events != null) {
        eventList = events;
      } else {
        eventList = [];
        hasError = true;
        errorMessage = "Etkinlikler yüklenemedi. Lütfen tekrar deneyin.";
      }
      print('DEBUG eventList after set: $eventList');
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      eventList = [];
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<void> retryFetchEvents() async {
    await fetchEvents();
  }

  @action
  Future<bool> addEvent(EventModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _eventRepository.addEvent(model);
      if (result != null) {
        await fetchEvents();
        return true;
      } else {
        hasError = true;
        errorMessage = "Etkinlik eklenemedi. Lütfen tekrar deneyin.";
        return false;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> updateEvent(EventModel model) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _eventRepository.updateEvent(model);
      if (result != null) {
        await fetchEvents();
        return true;
      } else {
        hasError = true;
        errorMessage = "Etkinlik güncellenemedi. Lütfen tekrar deneyin.";
        return false;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> deleteEvent(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final result = await _eventRepository.deleteEvent(id);
      if (result) {
        await fetchEvents();
        return true;
      } else {
        hasError = true;
        errorMessage = "Etkinlik silinemedi. Lütfen tekrar deneyin.";
        return false;
      }
    } catch (e) {
      hasError = true;
      errorMessage = e.toString();
      return false;
    } finally {
      isLoading = false;
    }
  }
}
