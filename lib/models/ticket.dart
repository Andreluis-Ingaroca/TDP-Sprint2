import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';
import 'package:lexp/models/user.dart';

part 'ticket.g.dart';

@JsonSerializable()
class TicketModel extends BaseModel {
  final int? idTicket;
  final int idUser;
  final int categoryType;
  String description;
  UserModel? user;
  final DateTime? fecReg;

  TicketModel(
    super.status, {
    this.idTicket,
    this.fecReg,
    this.user,
    required this.idUser,
    required this.categoryType,
    required this.description,
  });

  factory TicketModel.fromJson(Map<String, dynamic> json) => _$TicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketModelToJson(this);
}
