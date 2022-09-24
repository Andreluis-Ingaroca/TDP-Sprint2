import 'package:lexp/models/base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'book.g.dart';

@JsonSerializable()
class BookModel extends BaseModel {
  final int idBook;
  String bookname;
  int badgeCost;
  String multimedia;
  String portrait;

  BookModel(
    super.status, {
    required this.idBook,
    required this.bookname,
    required this.badgeCost,
    required this.multimedia,
    required this.portrait,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => _$BookModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookModelToJson(this);
}
