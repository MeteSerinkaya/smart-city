// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchModel _$SearchModelFromJson(Map<String, dynamic> json) => SearchModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  description: json['description'] as String?,
  imageUrl: json['imageUrl'] as String?,
  iconUrl: json['iconUrl'] as String?,
  type: json['type'] as String?,
  publishedAt: SearchModel._dateTimeFromJson(json['publishedAt']),
  date: SearchModel._dateTimeFromJson(json['date']),
);

Map<String, dynamic> _$SearchModelToJson(SearchModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'iconUrl': instance.iconUrl,
      'type': instance.type,
      'publishedAt': SearchModel._dateTimeToJson(instance.publishedAt),
      'date': SearchModel._dateTimeToJson(instance.date),
    };
