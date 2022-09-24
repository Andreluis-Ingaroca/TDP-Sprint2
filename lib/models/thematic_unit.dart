import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';
import 'package:lexp/models/category.dart';
import 'package:lexp/models/content.dart';

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
  final CategoryModel? category;
  List<ContentModel>? listOfContent;

  ThematicUnitModel(super.status, this.thematicUnitName, this.description, this.portrait, this.nivel, this.minCalification, this.starRate,
      this.nTime, this.nBadge, this.category,
      {required this.idThematicUnit, required this.idCategory, this.listOfContent});

  factory ThematicUnitModel.fromJson(Map<String, dynamic> json) => _$ThematicUnitModelFromJson(json);

  Map<String, dynamic> toJson() => _$ThematicUnitModelToJson(this);
}
