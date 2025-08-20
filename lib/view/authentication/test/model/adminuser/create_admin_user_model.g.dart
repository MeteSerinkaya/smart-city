// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_admin_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateAdminUserModel _$CreateAdminUserModelFromJson(
  Map<String, dynamic> json,
) => CreateAdminUserModel(
  username: json['username'] as String?,
  password: json['password'] as String?,
  role: json['role'] as String? ?? 'admin',
);

Map<String, dynamic> _$CreateAdminUserModelToJson(
  CreateAdminUserModel instance,
) => <String, dynamic>{
  'username': instance.username,
  'password': instance.password,
  'role': instance.role,
};
