import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'city_service_model.g.dart';

@JsonSerializable()
class CityServiceModel extends BaseModel<CityServiceModel> {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'iconUrl')
  String? iconUrl;

  CityServiceModel({this.id, this.title, this.description, this.iconUrl});

  factory CityServiceModel.fromJson(Map<String, dynamic> json) => _$CityServiceModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$CityServiceModelToJson(this);

  @override
  CityServiceModel fromJson(Map<String, dynamic> json) {
    return _$CityServiceModelFromJson(json);
  }
}
