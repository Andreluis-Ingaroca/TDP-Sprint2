// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'thematic_unit.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ThematicUnitModel _$ThematicUnitModelFromJson(Map<String, dynamic> json) =>
    ThematicUnitModel(
      json['status'] as int,
      json['thematicUnitName'] as String,
      json['description'] as String,
      json['portrait'] as String,
      json['nivel'] as int,
      json['minCalification'] as int,
      json['starRate'] as int,
      json['nTime'] as int,
      json['nBadge'] as int,
      idThematicUnit: json['idThematicUnit'] as int,
      idCategory: json['idCategory'] as int,
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
    };