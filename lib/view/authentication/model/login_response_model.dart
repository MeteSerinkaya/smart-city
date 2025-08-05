import 'package:json_annotation/json_annotation.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  @JsonKey(name: 'userName')
  String? username;
  String? accessToken;
  int? expiresIn;
  String? role;

  LoginResponseModel({this.username, this.accessToken, this.expiresIn, this.role});

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => _$LoginResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
