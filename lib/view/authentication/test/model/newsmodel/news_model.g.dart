// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsModel _$NewsModelFromJson(Map<String, dynamic> json) => NewsModel(
  id: (json['id'] as num?)?.toInt(),
  title: json['title'] as String?,
  content: json['content'] as String?,
  imageUrl: json['imageUrl'] as String?,
  publishedAt: NewsModel._dateTimeFromJson(json['publishedAt']),
);

Map<String, dynamic> _$NewsModelToJson(NewsModel instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'content': instance.content,
  'imageUrl': instance.imageUrl,
  'publishedAt': NewsModel._dateTimeToJson(instance.publishedAt),
};
