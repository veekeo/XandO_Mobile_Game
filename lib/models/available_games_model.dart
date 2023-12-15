// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

List<AvailableGamesModel> availableGamesModelFromJson(String str) =>
    List<AvailableGamesModel>.from(
        json.decode(str).map((x) => AvailableGamesModel.fromJson(x)));

String availableGamesModelToJson(List<AvailableGamesModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AvailableGamesModel {
  int? id;
  String? title;
  String? stake;
  User? user;

  AvailableGamesModel({
    this.id,
    this.title,
    this.stake,
    this.user,
  });

  factory AvailableGamesModel.fromJson(Map<String, dynamic> json) =>
      AvailableGamesModel(
        id: json["id"],
        title: json["title"],
        stake: json["stake"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "stake": stake,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? username;

  User({
    this.id,
    this.username,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
      };
}
