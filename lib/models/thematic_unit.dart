import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';

part 'thematic_unit.g.dart';

@JsonSerializable()
class ThematicUnitModel extends BaseModel {
  final int idThematicUnit;
  String thematicUnitName;
  final int idCategory;
  String description;
  String portrait;
  int nivel;
  int minCalification;
  int starRate;
  int nTime;
  int nBadge;

  ThematicUnitModel(super.status, this.thematicUnitName, this.description, this.portrait, this.nivel, this.minCalification, this.starRate,
      this.nTime, this.nBadge,
      {required this.idThematicUnit, required this.idCategory});

  factory ThematicUnitModel.fromJson(Map<String, dynamic> json) => _$ThematicUnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThematicUnitModelToJson(this);
}