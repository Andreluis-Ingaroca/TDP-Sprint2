// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      json['status'] as int?,
      idCategory: json['idCategory'] as int,
      categoryName: json['categoryName'] as String,
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idCategory': instance.idCategory,
      'categoryName': instance.categoryName,
    };
