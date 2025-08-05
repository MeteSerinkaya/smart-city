// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponseModel _$LoginResponseModelFromJson(Map<String, dynamic> json) =>
    LoginResponseModel(
      username: json['userName'] as String?,
      accessToken: json['accessToken'] as String?,
      expiresIn: (json['expiresIn'] as num?)?.toInt(),
      role: json['role'] as String?,
    );

Map<String, dynamic> _$LoginResponseModelToJson(LoginResponseModel instance) =>
    <String, dynamic>{
      'userName': instance.username,
      'accessToken': instance.accessToken,
      'expiresIn': instance.expiresIn,
      'role': instance.role,
    };
