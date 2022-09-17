import 'package:lexp/models/base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class CategoryModel extends BaseModel {
  final int idCategory;
  String categoryName;

  CategoryModel(
    super.status, {
    required this.idCategory,
    required this.categoryName,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
