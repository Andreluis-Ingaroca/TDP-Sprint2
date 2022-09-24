// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thematic_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThematicUnitModel _$ThematicUnitModelFromJson(Map<String, dynamic> json) =>
    ThematicUnitModel(
      json['status'] as int?,
      json['thematicUnitName'] as String,
      json['description'] as String,
      json['portrait'] as String,
      json['nivel'] as int,
      json['minCalification'] as int,
      json['starRate'] as int,
      json['nTime'] as int,
      json['nBadge'] as int,
      json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      idThematicUnit: json['idThematicUnit'] as int,
      idCategory: json['idCategory'] as int,
      listOfContent: (json['listOfContent'] as List<dynamic>?)
          ?.map((e) => ContentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ThematicUnitModelToJson(ThematicUnitModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idThematicUnit': instance.idThematicUnit,
      'thematicUnitName': instance.thematicUnitName,
      'idCategory': instance.idCategory,
      'description': instance.description,
      'portrait': instance.portrait,
      'nivel': instance.nivel,
      'minCalification': instance.minCalification,
      'starRate': instance.starRate,
      'nTime': instance.nTime,
      'nBadge': instance.nBadge,
      'category': instance.category,
      'listOfContent': instance.listOfContent,
    };
