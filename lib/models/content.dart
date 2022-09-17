import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';

part 'content.g.dart';

@JsonSerializable()
class ContentModel extends BaseModel {
  final int idContent;
  String contentName;
  final int idThematicUnit;
  int posicion;
  String multimedia;
  ContentModel(super.status, this.contentName, this.posicion, this.multimedia,
      {required this.idContent, required this.idThematicUnit});

  factory ContentModel.fromJson(Map<String, dynamic> json) => _$ContentModelFromJson(json);

  Map<String, dynamic> toJson() => _$ContentModelToJson(this);
}
