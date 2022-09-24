// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserBookModel _$UserBookModelFromJson(Map<String, dynamic> json) =>
    UserBookModel(
      json['status'] as int?,
      json['idBook'] as int,
      json['book'] == null
          ? null
          : BookModel.fromJson(json['book'] as Map<String, dynamic>),
      idUxB: json['idUxB'] as int,
      idUser: json['idUser'] as int,
    );

Map<String, dynamic> _$UserBookModelToJson(UserBookModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idUxB': instance.idUxB,
      'idUser': instance.idUser,
      'idBook': instance.idBook,
      'book': instance.book,
    };
