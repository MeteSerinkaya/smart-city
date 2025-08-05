// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AnnouncementModel _$AnnouncementModelFromJson(Map<String, dynamic> json) =>
    AnnouncementModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      content: json['content'] as String?,
      date: AnnouncementModel._dateTimeFromJson(json['date']),
    );

Map<String, dynamic> _$AnnouncementModelToJson(AnnouncementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'date': AnnouncementModel._dateTimeToJson(instance.date),
    };
