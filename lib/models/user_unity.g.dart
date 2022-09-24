// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_unity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUnityModel _$UserUnityModelFromJson(Map<String, dynamic> json) =>
    UserUnityModel(
      json['status'] as int?,
      json['finalCalification'] as int?,
      json['thematicUnit'] == null
          ? null
          : ThematicUnitModel.fromJson(
              json['thematicUnit'] as Map<String, dynamic>),
      json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      idUxU: json['idUxU'] as int,
      idThematicUnit: json['idThematicUnit'] as int,
      idUser: json['idUser'] as int,
      advQtty: json['advQtty'] as int,
      badgeName: json['badgeName'] as String,
    );

Map<String, dynamic> _$UserUnityModelToJson(UserUnityModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idUxU': instance.idUxU,
      'idThematicUnit': instance.idThematicUnit,
      'idUser': instance.idUser,
      'finalCalification': instance.finalCalification,
      'advQtty': instance.advQtty,
      'badgeName': instance.badgeName,
      'thematicUnit': instance.thematicUnit,
      'user': instance.user,
    };
