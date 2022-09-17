// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContentModel _$ContentModelFromJson(Map<String, dynamic> json) => ContentModel(
      json['status'] as int,
      json['contentName'] as String,
      json['posicion'] as int,
      json['multimedia'] as String,
      idContent: json['idContent'] as int,
      idThematicUnit: json['idThematicUnit'] as int,
    );

Map<String, dynamic> _$ContentModelToJson(ContentModel instance) => <String, dynamic>{
      'status': instance.status,
      'idContent': instance.idContent,
      'contentName': instance.contentName,
      'idThematicUnit': instance.idThematicUnit,
      'posicion': instance.posicion,
      'multimedia': instance.multimedia,
    };
