import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'create_admin_user_model.g.dart';

@JsonSerializable()
class CreateAdminUserModel extends BaseModel<CreateAdminUserModel> {
  @JsonKey(name: 'username')
  String? username;

  @JsonKey(name: 'password')
  String? password;

  @JsonKey(name: 'role')
  String? role;

  CreateAdminUserModel({this.username, this.password, this.role = 'admin'});

  factory CreateAdminUserModel.fromJson(Map<String, dynamic> json) => _$CreateAdminUserModelFromJson(json);

  @override
  Map<String, dynamic> toJson() => _$CreateAdminUserModelToJson(this);

  @override
  CreateAdminUserModel fromJson(Map<String, dynamic> json) {
    return _$CreateAdminUserModelFromJson(json);
  }
}
