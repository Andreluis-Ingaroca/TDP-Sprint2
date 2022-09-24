import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';

part 'question.g.dart';

@JsonSerializable()
class QuestionModel extends BaseModel {
  final int idQuestion;
  String label;
  String alternative1;
  String alternative2;
  String alternative3;
  String alternative4;
  int answer;
  final int idExamen;

  QuestionModel(super.status, this.label, this.alternative1, this.alternative2, this.alternative3, this.alternative4, this.answer,
      {required this.idQuestion, required this.idExamen});

  factory QuestionModel.fromJson(Map<String, dynamic> json) => _$QuestionModelFromJson(json);

  Map<String, dynamic> toJson() => _$QuestionModelToJson(this);
}
