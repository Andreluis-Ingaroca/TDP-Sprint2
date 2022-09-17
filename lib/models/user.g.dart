// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      json['status'] as int,
      idUser: json['idUser'] as int,
      username: json['username'] as String,
      email: json['email'] as String,
      timeQtty: json['timeQtty'] as int,
      preferences: json['preferences'] as int,
      pw: json['pw'] as String,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'status': instance.status,
      'idUser': instance.idUser,
      'username': instance.username,
      'email': instance.email,
      'timeQtty': instance.timeQtty,
      'preferences': instance.preferences,
      'pw': instance.pw,
    };
