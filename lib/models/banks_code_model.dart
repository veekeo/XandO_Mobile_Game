// To parse this JSON data, do
//
//     final banksCodeModel = banksCodeModelFromJson(jsonString);

import 'dart:convert';

List<BanksCodeModel> banksCodeModelFromJson(String str) =>
    List<BanksCodeModel>.from(
        json.decode(str).map((x) => BanksCodeModel.fromJson(x)));

String banksCodeModelToJson(List<BanksCodeModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BanksCodeModel {
  String name;
  String slug;
  String code;
  String ussd;
  String logo;

  BanksCodeModel({
    required this.name,
    required this.slug,
    required this.code,
    required this.ussd,
    required this.logo,
  });

  factory BanksCodeModel.fromJson(Map<String, dynamic> json) => BanksCodeModel(
        name: json["name"],
        slug: json["slug"],
        code: json["code"],
        ussd: json["ussd"],
        logo: json["logo"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "slug": slug,
        "code": code,
        "ussd": ussd,
        "logo": logo,
      };
}
