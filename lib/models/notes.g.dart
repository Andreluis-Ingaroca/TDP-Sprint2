// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotesModel _$NotesModelFromJson(Map<String, dynamic> json) => NotesModel(
      json['status'] as int?,
      json['content'] == null
          ? null
          : ContentModel.fromJson(json['content'] as Map<String, dynamic>),
      idUxC: json['idUxC'] as int?,
      idContent: json['idContent'] as int,
      idUxU: json['idUxU'] as int,
      notes: json['notes'] as String,
    );

Map<String, dynamic> _$NotesModelToJson(NotesModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idUxC': instance.idUxC,
      'idContent': instance.idContent,
      'idUxU': instance.idUxU,
      'notes': instance.notes,
      'content': instance.content,
    };
