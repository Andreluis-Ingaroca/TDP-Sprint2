import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';

part 'user_unity.g.dart';

@JsonSerializable()
class UserUnityModel extends BaseModel {
  final int idUxU;

  final int idThematicUnit;

  final int idUser;

  int finalCalification;

  int payQtty;

  String badgeName;

  UserUnityModel(
    super.status,
    this.finalCalification, {
    required this.idUxU,
    required this.idThematicUnit,
    required this.idUser,
    required this.payQtty,
    required this.badgeName,
  });

  factory UserUnityModel.fromJson(Map<String, dynamic> json) =>
      _$UserUnityModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserUnityModelToJson(this);
}
