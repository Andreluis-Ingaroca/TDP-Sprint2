// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'exam.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExamModel _$ExamModelFromJson(Map<String, dynamic> json) => ExamModel(
      json['status'] as int?,
      json['nExamen'] as String,
      idExamen: json['idExamen'] as int,
      idThematicUnit: json['idThematicUnit'] as int?,
      idContent: json['idContent'] as int?,
      thematicUnit: json['thematicUnit'] == null
          ? null
          : ThematicUnitModel.fromJson(
              json['thematicUnit'] as Map<String, dynamic>),
      content: json['content'] == null
          ? null
          : ContentModel.fromJson(json['content'] as Map<String, dynamic>),
      questions: (json['questions'] as List<dynamic>?)
          ?.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ExamModelToJson(ExamModel instance) => <String, dynamic>{
      'status': instance.status,
      'idExamen': instance.idExamen,
      'idThematicUnit': instance.idThematicUnit,
      'idContent': instance.idContent,
      'nExamen': instance.nExamen,
      'thematicUnit': instance.thematicUnit,
      'content': instance.content,
      'questions': instance.questions,
    };
