import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'admin_user_model.g.dart';

@JsonSerializable()
class AdminUserModel extends BaseModel<AdminUserModel> {
  @JsonKey(name: 'id')
  int? id;

  @JsonKey(name: 'userName')
  String? username;

  @JsonKey(name: 'role')
  String? role;

  @JsonKey(name: 'createdAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? createdAt;

  AdminUserModel({this.id, this.username, this.role, this.createdAt});

  factory AdminUserModel.fromJson(Map<String, dynamic> json) => _$AdminUserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$AdminUserModelToJson(this);

  @override
  AdminUserModel fromJson(Map<String, dynamic> json) {
    return _$AdminUserModelFromJson(json);
  }

  static DateTime? _dateTimeFromJson(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  static String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();

  AdminUserModel copyWith({int? id, String? username, String? role, DateTime? createdAt}) {
    return AdminUserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
