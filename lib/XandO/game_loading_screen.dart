import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:xando/XandO/game_play.dart';

class GameLoadingScreen extends StatefulWidget {
  const GameLoadingScreen(
      {super.key, required this.gameId, required this.stake});
  final String gameId;
  final double stake;

  @override
  State<GameLoadingScreen> createState() => _GameLoadingScreenState();
}

class _GameLoadingScreenState extends State<GameLoadingScreen>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
    // // print(dbProvider.usr);

    Future.delayed(
      const Duration(seconds: 10),
      () {
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (context) {
          return XandOGameScreen(
            gameId: widget.gameId,
            stake: widget.stake,
          );
        }));
      },
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 150,
              width: 150,
              child: RiveAnimation.asset(
                'assets/images/loader.riv',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Loading',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Bold',
                fontSize: 20,
              ),
            ),
            Text(
              ' the ultimate X and O experience... ',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Medium',
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
