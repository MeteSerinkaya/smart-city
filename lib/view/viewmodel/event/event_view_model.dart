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
  EventModel? singleEvent;

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
      // Hemen boş state'e geç, hiç bekleme yok
      if (events != null && events.isNotEmpty) {
        eventList = events;
      } else {
        eventList = [];
        hasError = false;
        errorMessage = null;
      }
      print('DEBUG eventList after set: $eventList');
    } catch (e) {
      // Hata durumunda da hemen boş state'e geç
      hasError = false;
      errorMessage = null;
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
  Future<void> getEventById(int id) async {
    isLoading = true;
    hasError = false;
    errorMessage = null;
    
    try {
      final event = await _eventRepository.getEventById(id);
      if (event != null) {
        singleEvent = event;
      } else {
        hasError = true;
        errorMessage = 'Etkinlik bulunamadı';
      }
    } catch (e) {
      hasError = true;
      errorMessage = 'Etkinlik yüklenirken hata oluştu';
    } finally {
      isLoading = false;
    }
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
