// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'book.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookModel _$BookModelFromJson(Map<String, dynamic> json) => BookModel(
      json['status'] as int?,
      idBook: json['idBook'] as int,
      bookname: json['bookname'] as String,
      badgeCost: json['badgeCost'] as int,
      multimedia: json['multimedia'] as String,
      portrait: json['portrait'] as String,
    );

Map<String, dynamic> _$BookModelToJson(BookModel instance) => <String, dynamic>{
      'status': instance.status,
      'idBook': instance.idBook,
      'bookname': instance.bookname,
      'badgeCost': instance.badgeCost,
      'multimedia': instance.multimedia,
      'portrait': instance.portrait,
    };
