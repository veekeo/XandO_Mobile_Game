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
  String? gameId;
  String? title;
  String? stake;
  bool? state;
  User? user;

  AvailableGamesModel({
    this.id,
    this.gameId,
    this.title,
    this.stake,
    this.state,
    this.user,
  });

  factory AvailableGamesModel.fromJson(Map<String, dynamic> json) =>
      AvailableGamesModel(
        id: json["id"],
        title: json["title"],
        gameId: json['game_id'],
        stake: json["stake"],
        state: json['state'],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "game_id": gameId,
        "stake": stake,
        "state": state,
        "user": user?.toJson(),
      };
}

class User {
  String? id;
  String? username;
  String? avatar;
  String? deviceToken;

  User({
    this.id,
    this.username,
    this.avatar,
    this.deviceToken,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        avatar: json["avatar"],
        deviceToken: json["devicetoken"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "avatar": avatar,
        "devicetoken": deviceToken,
      };
}
