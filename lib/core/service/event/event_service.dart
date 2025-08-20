import 'package:smart_city/core/init/network/network_manager.dart';
import 'package:smart_city/view/authentication/test/model/eventmodel/event_model.dart';

abstract class IEventService {
  Future<List<EventModel>?> fetchEvents();
  Future<EventModel?> getEventById(int id);
  Future<EventModel?> addEvent(EventModel model);
  Future<EventModel?> updateEvent(EventModel model);
  Future<bool> deleteEvent(int id);
}

class EventService extends IEventService {
  @override
  Future<List<EventModel>?> fetchEvents() async {
    try {
      final response = await NetworkManager.instance.dioGet('events', EventModel());
      if (response != null && response is List) {
        return response.cast<EventModel>();
      }
      return null;
    } catch (e) {
      print("EventService fetchEvents error: $e");
      return null;
    }
  }

  @override
  Future<EventModel?> getEventById(int id) async {
    try {
      final response = await NetworkManager.instance.dioGet('events/$id', EventModel());
      if (response != null && response is EventModel) {
        return response;
      }
      return null;
    } catch (e) {
      print("EventService getEventById error: $e");
      return null;
    }
  }

  @override
  Future<EventModel?> addEvent(EventModel model) async {
    try {
      final data = model.toJson();
      data.remove('id');
      final response = await NetworkManager.instance.dio.post('events', data: data);
      
      if (response.statusCode == 201) {
        return EventModel.fromJson(response.data);
      }
      return null;
    } catch (e) {
      print("EventService addEvent error: $e");
      return null;
    }
  }

  @override
  Future<EventModel?> updateEvent(EventModel model) async {
    try {
      final response = await NetworkManager.instance.dio.put('events/${model.id}', data: model.toJson());
      
      if (response.statusCode == 204) {
        return model; // PUT returns 204 No Content, so return the updated model
      }
      return null;
    } catch (e) {
      print("EventService updateEvent error: $e");
      return null;
    }
  }

  @override
  Future<bool> deleteEvent(int id) async {
    try {
      final response = await NetworkManager.instance.dio.delete('events/$id');
      return response.statusCode == 204;
    } catch (e) {
      print("EventService deleteEvent error: $e");
      return false;
    }
  }
}
