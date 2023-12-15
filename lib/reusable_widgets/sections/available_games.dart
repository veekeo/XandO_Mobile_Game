// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/components/game_card.dart';

class LoadAvailableGames extends StatelessWidget {
  const LoadAvailableGames({
    super.key,
    required this.userImage,
    required this.userName,
    required this.stake,
  });

  final String userImage;
  final String userName;
  final String stake;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(13, 10, 13, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          GameCard(
            image: 'assets/images/scott_brown.png',
            username: 'Scott Brown',
            price: '4000.000',
            buttonText: 'Join',
            onTap: () {},
            cardColor: Color.fromARGB(255, 15, 22, 44),
          ),
        ],
      ),
    );
  }
}
