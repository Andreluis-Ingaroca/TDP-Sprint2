import 'package:lexp/models/base.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/book.dart';

part 'user_book.g.dart';

@JsonSerializable()
class UserBookModel extends BaseModel {
  final int idUxB;
  final int idUser;
  final int idBook;
  BookModel? book;

  UserBookModel(super.status, this.idBook, this.book, {required this.idUxB, required this.idUser});

  factory UserBookModel.fromJson(Map<String, dynamic> json) => _$UserBookModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserBookModelToJson(this);
}
