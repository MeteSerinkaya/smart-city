// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserModel _$AdminUserModelFromJson(Map<String, dynamic> json) =>
    AdminUserModel(
      id: (json['id'] as num?)?.toInt(),
      username: json['userName'] as String?,
      role: json['role'] as String?,
      createdAt: AdminUserModel._dateTimeFromJson(json['createdAt']),
    );

Map<String, dynamic> _$AdminUserModelToJson(AdminUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userName': instance.username,
      'role': instance.role,
      'createdAt': AdminUserModel._dateTimeToJson(instance.createdAt),
    };
