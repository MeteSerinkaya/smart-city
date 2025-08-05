import 'package:json_annotation/json_annotation.dart';
import 'package:smart_city/core/base/model/base_model.dart';

part 'project_model.g.dart';

@JsonSerializable()
class ProjectModel extends BaseModel<ProjectModel> {
  @JsonKey(name: 'id')
  int? id;
  @JsonKey(name: 'title')
  String? title;
  @JsonKey(name: 'description')
  String? description;
  @JsonKey(name: 'imageUrl')
  String? imageUrl;

  ProjectModel({this.id, this.title, this.description, this.imageUrl});

  factory ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);
  @override
  Map<String, dynamic> toJson() => _$ProjectModelToJson(this);

  @override
  ProjectModel fromJson(Map<String, dynamic> json) {
    return _$ProjectModelFromJson(json);
  }
}
