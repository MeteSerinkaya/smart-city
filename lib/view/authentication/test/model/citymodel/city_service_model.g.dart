// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_service_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityServiceModel _$CityServiceModelFromJson(Map<String, dynamic> json) =>
    CityServiceModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
    );

Map<String, dynamic> _$CityServiceModelToJson(CityServiceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
    };
