import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';
import 'package:lexp/models/content.dart';
import 'package:lexp/models/question.dart';
import 'package:lexp/models/thematic_unit.dart';

part 'exam.g.dart';

@JsonSerializable()
class ExamModel extends BaseModel {
  final int idExamen;
  int? idThematicUnit;
  int? idContent;
  String nExamen;
  ThematicUnitModel? thematicUnit;
  ContentModel? content;
  List<QuestionModel>? questions;

  ExamModel(super.status, this.nExamen,
      {required this.idExamen, this.idThematicUnit, this.idContent, this.thematicUnit, this.content, this.questions});

  factory ExamModel.fromJson(Map<String, dynamic> json) => _$ExamModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExamModelToJson(this);
}
