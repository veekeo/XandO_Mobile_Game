// To parse this JSON data, do
//
//     final affliateUserModel = affliateUserModelFromJson(jsonString);

import 'dart:convert';

AffliateUserModel affliateUserModelFromJson(String str) =>
    AffliateUserModel.fromJson(json.decode(str));

String affliateUserModelToJson(AffliateUserModel data) =>
    json.encode(data.toJson());

class AffliateUserModel {
  int? id;
  String? affiliateCode;
  String? gamer;
  int? coin;

  AffliateUserModel({
    this.id,
    this.affiliateCode,
    this.gamer,
    this.coin,
  });

  factory AffliateUserModel.fromJson(Map<String, dynamic> json) =>
      AffliateUserModel(
          id: json["id"],
          affiliateCode: json["affiliate_code"],
          gamer: json["gamer"],
          coin: json["coin"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "affiliate_code": affiliateCode,
        "gamer": gamer,
        "coin": coin,
      };
}
