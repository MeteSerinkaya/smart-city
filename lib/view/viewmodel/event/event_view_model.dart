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
      if (events != null && events.isNotEmpty) {
        eventList = events;
      } else {
        // API yanıt vermezse veya boş data gelirse hemen boş state'e geç
        eventList = [];
        hasError = false; // Error state gösterme, boş state göster
        errorMessage = null;
      }
      print('DEBUG eventList after set: $eventList');
    } catch (e) {
      // Hata durumunda da boş state'e geç, error state gösterme
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
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
        hasError = false; // Error state gösterme
        return false;
      }
    } catch (e) {
      hasError = false; // Error state gösterme
      return false;
    } finally {
      isLoading = false;
    }
  }
}
