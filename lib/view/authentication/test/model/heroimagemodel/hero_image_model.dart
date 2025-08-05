import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'hero_image_model.g.dart';

@JsonSerializable()
class HeroImageModel extends BaseModel<HeroImageModel> {
  @JsonKey(name: 'id')
  int? id;
  
  @JsonKey(name: 'imageUrl')
  String? imageUrl;
  
  @JsonKey(name: 'title')
  String? title;
  
  @JsonKey(name: 'description')
  String? description;
  
  @JsonKey(name: 'createdAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? createdAt;

  HeroImageModel({this.id, this.imageUrl, this.title, this.description, this.createdAt});

  factory HeroImageModel.fromJson(Map<String, dynamic> json) => _$HeroImageModelFromJson(json);
  
  @override
  Map<String, dynamic> toJson() => _$HeroImageModelToJson(this);

  @override
  HeroImageModel fromJson(Map<String, dynamic> json) {
    return _$HeroImageModelFromJson(json);
  }

  static DateTime? _dateTimeFromJson(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }
  
  static String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();
} 