import 'package:json_annotation/json_annotation.dart';
import 'package:lexp/models/base.dart';
import 'package:lexp/models/thematic_unit.dart';
import 'package:lexp/models/user.dart';

part 'user_unity.g.dart';

@JsonSerializable()
class UserUnityModel extends BaseModel {
  final int idUxU;

  final int idThematicUnit;

  final int idUser;

  int? finalCalification;

  int advQtty;

  String badgeName;

  ThematicUnitModel? thematicUnit;

  UserModel? user;

  UserUnityModel(
    super.status,
    this.finalCalification,
    this.thematicUnit,
    this.user, {
    required this.idUxU,
    required this.idThematicUnit,
    required this.idUser,
    required this.advQtty,
    required this.badgeName,
  });

  factory UserUnityModel.fromJson(Map<String, dynamic> json) => _$UserUnityModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserUnityModelToJson(this);
}
