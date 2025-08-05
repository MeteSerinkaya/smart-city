import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'news_model.g.dart';

@JsonSerializable()
class NewsModel extends BaseModel<NewsModel> {
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'content')
  String? content;
  @JsonKey(name: 'imageUrl')
  String? imageUrl;
  @JsonKey(name: 'publishedAt', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? publishedAt;

  NewsModel({this.id, this.title, this.content, this.imageUrl, this.publishedAt});

  factory NewsModel.fromJson(Map<String, dynamic> json) => _$NewsModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$NewsModelToJson(this);

  @override
  NewsModel fromJson(Map<String, dynamic> json) {
    return _$NewsModelFromJson(json);
  }

  static DateTime? _dateTimeFromJson(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }
  static String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();
}
