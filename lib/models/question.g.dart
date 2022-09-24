// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    QuestionModel(
      json['status'] as int?,
      json['label'] as String,
      json['alternative1'] as String,
      json['alternative2'] as String,
      json['alternative3'] as String,
      json['alternative4'] as String,
      json['answer'] as int,
      idQuestion: json['idQuestion'] as int,
      idExamen: json['idExamen'] as int,
    );

Map<String, dynamic> _$QuestionModelToJson(QuestionModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idQuestion': instance.idQuestion,
      'label': instance.label,
      'alternative1': instance.alternative1,
      'alternative2': instance.alternative2,
      'alternative3': instance.alternative3,
      'alternative4': instance.alternative4,
      'answer': instance.answer,
      'idExamen': instance.idExamen,
    };
