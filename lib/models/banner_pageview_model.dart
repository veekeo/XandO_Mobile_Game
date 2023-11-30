import 'package:flutter/material.dart';

class BannerPageViewModel {
  late final String title;
  late final String body;
  late final String icon;
  late final Color backgroundColor;
  late final Color textColor;

  BannerPageViewModel({
    required this.title,
    required this.body,
    required this.icon,
    required this.backgroundColor,
    required this.textColor,
  });
}
