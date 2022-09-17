// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_unity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserUnityModel _$UserUnityModelFromJson(Map<String, dynamic> json) =>
    UserUnityModel(
      json['status'] as int,
      json['finalCalification'] as int,
      idUxU: json['idUxU'] as int,
      idThematicUnit: json['idThematicUnit'] as int,
      idUser: json['idUser'] as int,
      payQtty: json['payQtty'] as int,
      badgeName: json['badgeName'] as String,
    );

Map<String, dynamic> _$UserUnityModelToJson(UserUnityModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idUxU': instance.idUxU,
      'idThematicUnit': instance.idThematicUnit,
      'idUser': instance.idUser,
      'finalCalification': instance.finalCalification,
      'payQtty': instance.payQtty,
      'badgeName': instance.badgeName,
    };
