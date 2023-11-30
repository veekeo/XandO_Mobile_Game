// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:xando/models/banner_pageview_model.dart';

final List<BannerPageViewModel> bannerPageViewList = [
  BannerPageViewModel(
    title: 'Create Game',
    body:
        "Create your own Tic Tac Toe game, \nset the stakes, and invite a friend or \na player to join.",
    icon: 'assets/images/double_coins.png',
    backgroundColor: Color(0xFF3B4FFE),
    textColor: Colors.white,
  ),
  BannerPageViewModel(
    title: 'Quick Play',
    body:
        "Quickly join a Tic Tac Toe game, we \nhave a list of available games \nwith options to join.",
    icon: 'assets/images/tic-tac-toe_1.png',
    backgroundColor: Color(0xFFFDC101),
    textColor: Colors.black,
  ),
  BannerPageViewModel(
    title: 'Leaderboard',
    body:
        "Quickly join a Tic Tac Toe game, we \nhave a list of available games \nwith options to join.",
    icon: 'assets/images/leaderboard_icon.png',
    backgroundColor: Color(0xFFEB1D64),
    textColor: Colors.white,
  ),
];
