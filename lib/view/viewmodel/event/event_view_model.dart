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

  @action
  Future<void> fetchEvents() async {
    isLoading = true;
    final events = await _eventRepository.getEvents();
    print('DEBUG fetchEvents response: $events');
    eventList = events;
    print('DEBUG eventList after set: $eventList');
    isLoading = false;
  }

  @action
  Future<bool> addEvent(EventModel model) async {
    isLoading = true;
    final result = await _eventRepository.addEvent(model);
    await fetchEvents();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> updateEvent(EventModel model) async {
    isLoading = true;
    final result = await _eventRepository.updateEvent(model);
    await fetchEvents();
    isLoading = false;
    return result != null;
  }

  @action
  Future<bool> deleteEvent(int id) async {
    isLoading = true;
    final result = await _eventRepository.deleteEvent(id);
    await fetchEvents();
    isLoading = false;
    return result;
  }
}
