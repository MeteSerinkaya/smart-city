// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hero_image_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HeroImageModel _$HeroImageModelFromJson(Map<String, dynamic> json) =>
    HeroImageModel(
      id: (json['id'] as num?)?.toInt(),
      imageUrl: json['imageUrl'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      createdAt: HeroImageModel._dateTimeFromJson(json['createdAt']),
    );

Map<String, dynamic> _$HeroImageModelToJson(HeroImageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageUrl': instance.imageUrl,
      'title': instance.title,
      'description': instance.description,
      'createdAt': HeroImageModel._dateTimeToJson(instance.createdAt),
    };
