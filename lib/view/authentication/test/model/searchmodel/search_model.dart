import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'search_model.g.dart';

@JsonSerializable()
class SearchModel extends BaseModel<SearchModel> {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'content')
  String? content;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'imageUrl')
  String? imageUrl;
  @JsonKey(name: 'iconUrl')
  String? iconUrl;
  @JsonKey(name: 'type')
  String? type; // 'news', 'announcement', 'project', 'city_service'
  @JsonKey(name: 'publishedAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? publishedAt;
  @JsonKey(name: 'date', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? date;

  SearchModel({
    this.id,
    this.title,
    this.content,
    this.description,
    this.imageUrl,
    this.iconUrl,
    this.type,
    this.publishedAt,
    this.date,
  });

  factory SearchModel.fromJson(Map<String, dynamic> json) => _$SearchModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$SearchModelToJson(this);

  @override
  SearchModel fromJson(Map<String, dynamic> json) {
    return _$SearchModelFromJson(json);
  }

  static DateTime? _dateTimeFromJson(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }

  static String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();
}
