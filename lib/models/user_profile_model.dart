// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  String? contact;
  String? dateOfBirth;
  String? googleId;
  String? username;
  String? password;
  Gamedata? gamedata;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.contact,
    this.dateOfBirth,
    this.googleId,
    this.username,
    this.password,
    this.gamedata,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        contact: json["contact"],
        dateOfBirth: json["date_of_birth"],
        googleId: json["google_id"],
        username: json["username"],
        password: json["password"],
        gamedata: Gamedata.fromJson(json["gamedata"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "contact": contact,
        "date_of_birth": dateOfBirth,
        "google_id": googleId,
        "username": username,
        "password": password,
        "gamedata": gamedata?.toJson(),
      };
}

class Gamedata {
  int coin;

  Gamedata({
    required this.coin,
  });

  factory Gamedata.fromJson(Map<String, dynamic> json) => Gamedata(
        coin: json["coin"],
      );

  Map<String, dynamic> toJson() => {
        "coin": coin,
      };
}
