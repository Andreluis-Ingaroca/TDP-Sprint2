import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';
import 'package:lexp/models/content.dart';

part 'notes.g.dart';

@JsonSerializable()
class NotesModel extends BaseModel {
  final int? idUxC;
  final int idContent;
  final int idUxU;
  String notes;
  ContentModel? content;

  NotesModel(
    super.status,
    this.content, {
    this.idUxC,
    required this.idContent,
    required this.idUxU,
    required this.notes,
  });

  factory NotesModel.fromJson(Map<String, dynamic> json) => _$NotesModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotesModelToJson(this);
}
