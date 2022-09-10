import 'package:lexp/models/base.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class UserModel extends BaseModel {
  final int idUser;
  final String username;
  final String email;
  final int timeQtty;
  final int preferences;
  final String pw;

  UserModel({
    required this.idUser,
    required this.username,
    required this.email,
    required this.timeQtty,
    required this.preferences,
    required this.pw,
    required super.status,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
