import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'event_model.g.dart';

@JsonSerializable()
class EventModel extends BaseModel<EventModel> {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'date', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? date;
  @JsonKey(name: 'location')
  String? location;
  @JsonKey(name: 'imageUrl')
  String? imageUrl;

  EventModel({this.id, this.title, this.description, this.date, this.location, this.imageUrl});

  factory EventModel.fromJson(Map<String, dynamic> json) => _$EventModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$EventModelToJson(this);

  @override
  EventModel fromJson(Map<String, dynamic> json) {
    return _$EventModelFromJson(json);
  }

  static DateTime? _dateTimeFromJson(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }
  static String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();
}
