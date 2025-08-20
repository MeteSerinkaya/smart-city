import 'package:smart_city/core/service/event/event_service.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';

abstract class IEventRepository {
  Future<List<EventModel>?> getEvents();
  Future<EventModel?> getEventById(int id);
  Future<EventModel?> addEvent(EventModel model);
  Future<EventModel?> updateEvent(EventModel model);
  Future<bool> deleteEvent(int id);
}

class EventRepository extends IEventRepository {
  final IEventService _eventService;

  EventRepository(this._eventService);

  @override
  Future<List<EventModel>?> getEvents() async {
    return await _eventService.fetchEvents();
  }

  @override
  Future<EventModel?> getEventById(int id) async {
    return await _eventService.getEventById(id);
  }

  @override
  Future<EventModel?> addEvent(EventModel model) async {
    return await _eventService.addEvent(model);
  }

  @override
  Future<EventModel?> updateEvent(EventModel model) async {
    return await _eventService.updateEvent(model);
  }

  @override
  Future<bool> deleteEvent(int id) async {
    return await _eventService.deleteEvent(id);
  }
}
