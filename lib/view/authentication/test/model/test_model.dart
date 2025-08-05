import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';
part 'test_model.g.dart';

@JsonSerializable()
class TestModel extends BaseModel {
  int? id;
  String? title;
  String? description;
  String? imageUrl;

  TestModel({this.id, this.title, this.description, this.imageUrl});

  @override
  Map<String, dynamic> toJson() {
    return _$TestModelToJson(this);
  }

  @override
  fromJson(Map<String, dynamic> json) {
    return _$TestModelFromJson(json);
  }
}
