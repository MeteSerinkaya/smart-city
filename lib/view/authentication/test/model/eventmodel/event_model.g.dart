// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventModel _$EventModelFromJson(Map<String, dynamic> json) => EventModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  description: json['description'] as String?,
  date: EventModel._dateTimeFromJson(json['date']),
  location: json['location'] as String?,
  imageUrl: json['imageUrl'] as String?,
);

Map<String, dynamic> _$EventModelToJson(EventModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'date': EventModel._dateTimeToJson(instance.date),
      'location': instance.location,
      'imageUrl': instance.imageUrl,
    };
