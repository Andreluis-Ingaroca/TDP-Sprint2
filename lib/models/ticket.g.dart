// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketModel _$TicketModelFromJson(Map<String, dynamic> json) => TicketModel(
      json['status'] as int?,
      idTicket: json['idTicket'] as int?,
      fecReg: json['fecReg'] == null
          ? null
          : DateTime.parse(json['fecReg'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      idUser: json['idUser'] as int,
      categoryType: json['categoryType'] as int,
      description: json['description'] as String,
    );

Map<String, dynamic> _$TicketModelToJson(TicketModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'idTicket': instance.idTicket,
      'idUser': instance.idUser,
      'categoryType': instance.categoryType,
      'description': instance.description,
      'user': instance.user,
      'fecReg': instance.fecReg?.toIso8601String(),
    };
