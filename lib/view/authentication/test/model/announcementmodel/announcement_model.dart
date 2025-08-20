import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'announcement_model.g.dart';

@JsonSerializable()
class AnnouncementModel extends BaseModel<AnnouncementModel> {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'content')
  String? content;
  @JsonKey(name: 'date', fromJson: _dateTimeFromJson, toJson: _dateTimeToJson)
  DateTime? date;

  AnnouncementModel({this.id, this.title, this.content, this.date});

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) => _$AnnouncementModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$AnnouncementModelToJson(this);

  @override
  AnnouncementModel fromJson(Map<String, dynamic> json) {
    return _$AnnouncementModelFromJson(json);
  }

  static DateTime? _dateTimeFromJson(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    if (date is String) return DateTime.tryParse(date);
    return null;
  }
  static String? _dateTimeToJson(DateTime? date) => date?.toIso8601String();

  
}
