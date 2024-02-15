// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Game/audio_provider.dart';
import 'package:xando/Providers/Game/create_game_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/XandO/components/all_dailog.dart';
import 'package:xando/XandO/components/player_container.dart';
import 'package:xando/XandO/components/winner_dailog.dart';
import 'package:xando/XandO/game_play.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/main_page.dart';
import 'package:xando/utils/snackbar_message.dart';

// ignore: must_be_immutable
class GameStreamBuilderWidget extends StatefulWidget {
  const GameStreamBuilderWidget({
    super.key,
    required this.gameId,
    required this.userId,
    required this.stake,
    required this.coin,
  });

  final String gameId;
  final String userId;
  final double stake;
  final int coin;

  @override
  State<GameStreamBuilderWidget> createState() =>
      _GameStreamBuilderWidgetState();
}

class _GameStreamBuilderWidgetState extends State<GameStreamBuilderWidget> {
  Future<void> updateUserStateIfNeeded({
    required String documentID,
    required bool hostState,
    required bool player2State,
    required bool exTurn,
    required bool ohTurn,
    required List<dynamic> displayExOh,
    required List<dynamic> matchedIndexes,
    required int filledBoxes,
    String? hostId,
    String? player2Id,
    String? hostAvatar,
    String? player2Avatar,
    required int attempts,
    required bool gameState,
    String? hostGameId,
    String? gameNumberId,
    bool? hasHostPlayed,
    bool? hasPlayer2Played,
    bool? isRunning,
    bool? winnerFound,
    required bool isHostWinner,
    required bool isPlayer2Winner,
  }) async {
    // Your logic to determine when to update user state
    if (shouldUpdateUserState) {
      final firestore = context.read<FireStoreServiceProvider>();
      await firestore.updateUserState(
        documentID: widget.gameId,
        hostState: hostState,
        player2State: player2State,
        exTurn: exTurn,
        ohTurn: ohTurn,
        displayExOh: displayExOh,
        matchedIndexes: matchedIndexes,
        filledBoxes: filledBoxes,
        attempts: attempts,
        gameState: gameState,
        hostAvatar: hostAvatar!,
        player2Avatar: player2Avatar!,
        hostId: hostId!,
        player2Id: player2Id!,
        hostGameId: hostGameId!,
        gameNumberId: gameNumberId!,
        hasHostPlayed: hasHostPlayed!,
        hasPlayer2Played: hasPlayer2Played!,
        isRunning: isRunning!,
        winnerFound: winnerFound!,
        isHostWinner: isHostWinner,
        isPlayer2Winner: isPlayer2Winner,
      );
    }
  }

  void updateTimer({
    required String documentID,
    required int seconds,
  }) async {
    final firestore = context.read<FireStoreServiceProvider>();
    await firestore.updateTimer(
      documentID: documentID,
      seconds: seconds,
    );
  }

  bool shouldUpdateUserState = false;
  bool hostState = true;
  bool player2State = true;
  int buttonClicked = 0;

  bool exTurn = true;
  bool ohTurn = false;
  // bool checkHost = false;
  // bool checkPlayer2 = false;
  String? hostGameId = '';
  String? gameNumberId = '';
  List<dynamic> displayExOh = [
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
  ];

  List<int> matchedIndexes = [];

  int filledBoxes = 0;
  int attempts = 0;
  String wonAmount = '';
  bool gameState = true;

  Timer? timer;
  static const maxSeconds = 60;
  int seconds = maxSeconds;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  //Timer Function
  void startTimer({
    required String documentID,
  }) {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
          updateTimer(documentID: documentID, seconds: seconds);
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          stream: FireStoreServiceProvider().getGameStream(widget.gameId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.none) {
              shouldUpdateUserState = true;
              hostState = false;
              player2State = false;
              return const NoConnectionWidget(message: 'Reconnecting...');
            }

            if (!snapshot.hasData) {
              shouldUpdateUserState = true;
              hostState = false;
              player2State = false;
              return const NoConnectionWidget(
                  message: 'Loading... \nplease wait.');
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              shouldUpdateUserState = true;
              hostState = false;
              player2State = false;
              return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        'assets/images/background.png', // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    );
            }

            

            if (snapshot.hasData && snapshot.data != null) {
              shouldUpdateUserState = true;
              hostState = true;
              player2State = true;

              final hostData = snapshot.data?['host'];
              final player2Data = snapshot.data?['player2'];
              gameState = snapshot.data?['state'];
              final gameData = snapshot.data!.data() as Map<String, dynamic>;

              //

              exTurn = gameData['host']['exTurn'];
              ohTurn = gameData['player2']['ohTurn'];
              final hostId = gameData['host']['hostId'];
              hostGameId = gameData['host']['hostId'];
              gameNumberId = gameData['host']['gameNumberId'];
              final player2Id = gameData['player2']['player2Id'];
              displayExOh = gameData['host']['displayExOh'];

              // Check if the current user is the host or player2
              bool isHost = widget.userId == hostId;
              bool isPlayer2 = widget.userId == player2Id;

              if (snapshot.connectionState == ConnectionState.none &&
                  widget.userId == hostId) {
                shouldUpdateUserState = true;
                hostState = false;
                player2State = true;
                return const NoConnectionWidget(
                    message: 'Waiting for host \nReconnecting...');
              } else if (snapshot.connectionState == ConnectionState.none &&
                  widget.userId == player2Id) {
                shouldUpdateUserState = true;
                hostState = true;
                player2State = false;
                return const NoConnectionWidget(
                    message: 'Waiting for player 2 \nReconnecting...');
              }
              //
              if (snapshot.hasError && widget.userId == hostId) {
                if (snapshot.error is FirebaseException &&
                    (snapshot.error as FirebaseException).code ==
                        'unavailable') {
                  shouldUpdateUserState = true;
                  hostState = false;
                  player2State = true;
                  return const NoConnectionWidget(
                    message: 'Player2 has lost connection. \nPlease wait.',
                  );
                }
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasError && widget.userId == player2Id) {
                // updateUserState(true, false);
                if (snapshot.error is FirebaseException &&
                    (snapshot.error as FirebaseException).code ==
                        'unavailable') {
                  shouldUpdateUserState = true;
                  hostState = true;
                  player2State = false;
                  return const NoConnectionWidget(
                    message: 'Player2 has lost connection. \nPlease wait.',
                  );
                }
              } else {
                if (isHost) {
                  final hasPlayer2Played = player2Data['hasPlayer2Played'];
                  final hasHostPlayed = hostData['hasHostPlayed'];
                  final isHostConnected = hostData['isHostConnected'];
                  final isPlayer2Connected = player2Data['isPlayer2Connected'];
                  final hostGameId = gameData['host']['hostGameId'];
                  final gameNumberId = gameData['host']['gameNumberId'];
                  final player2Id = gameData['player2']['player2Id'];
                  final hostId = gameData['host']['hostId'];
                  final hostAvatar = hostData['hostAvatar'];
                  final player2Avatar = player2Data['player2Avatar'];
                  final displayExOh =
                      List<String>.from(hostData['displayExOh']);
                  final matchedIndexes =
                      List<int>.from(hostData['matchedIndexes']);
                  final filledBoxes = hostData['filledBoxes'];
                  attempts = hostData['attempts'];
                  final isRunning = gameData['isRunning'];
                  final winnerFound = gameData['winnerFound'];
                  bool isHost = widget.userId == gameData['host']['hostId'];
                  bool isPlayer2 =
                      widget.userId == gameData['player2']['player2Id'];
                  final bool isHostWinner = hostData['isHostWinner'];
                  final bool isPlayer2Winner = player2Data['isPlayer2Winner'];
                  final int seconds = gameData['seconds'];

                  if (winnerFound == true && isHostWinner == true) {
                    _showDialog(
                      context: context,
                      winner: 'You won',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  } else if (winnerFound == true && isPlayer2Winner == true) {
                    _showDialog(
                      context: context,
                      winner: 'You lost',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  } else if (seconds == 0) {
                    _showDialog(
                      context: context,
                      winner: 'Time is up',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  } else if (isHostWinner && isPlayer2Winner) {
                    _clearBoard(
                        hostId: hostId,
                        gameNumberId: gameNumberId,
                        hostAvatar: hostAvatar,
                        player2Avatar: player2Avatar,
                        player2Id: player2Id,
                        hasHostPlayed: hasHostPlayed,
                        hasPlayer2Played: hasPlayer2Played,
                        isRunning: isRunning,
                        seconds: seconds,
                        gameState: gameState,
                        isHostConnected: isHostConnected,
                        isPlayer2Connected: isPlayer2Connected);
                    _showDialog(
                      context: context,
                      winner: 'Draw',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  }

                  if (snapshot.data == null) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        'assets/images/background.png', // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Player1Container(
                              image: hostAvatar,
                              indicator: 'assets/images/x_indicator.png',
                              isactive: exTurn,
                            ),
                            const SizedBox(width: 10),
                            Player2Container(
                              image: player2Avatar,
                              indicator: 'assets/images/o_indicator.png',
                              isactive: ohTurn,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          exTurn ? 'It\'s Your Turn!' : 'It\'s player 2 Turn',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        )
                            .animate(autoPlay: true)
                            .fadeIn(curve: Curves.easeIn, duration: 500.ms),
                        const SizedBox(height: 20),
                        Consumer<AudioProvider>(
                            builder: (context, audio, child) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: const Color(0xFF29197A),
                              border: Border.all(
                                color: const Color(0xFFFDC101),
                                width: 2.5,
                              ),
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 9,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: exTurn
                                      ? () {
                                          audio.isSoundOn
                                              ? audio
                                                  .playSound('assets/click.wav')
                                              : '';
                                          _tapped(
                                            index: index,
                                            isRunning: isRunning,
                                            winnerFound: winnerFound,
                                            documentID: widget.gameId,
                                            hostState: hostState,
                                            player2State: player2State,
                                            hostId: hostId,
                                            player2Id: player2Id,
                                            gameNumberId: gameNumberId,
                                            hostGameId: hostGameId,
                                            exTurn: exTurn,
                                            ohTurn: ohTurn,
                                            displayExOh: displayExOh,
                                            matchedIndexes: matchedIndexes,
                                            filledBoxes: filledBoxes,
                                            attempts: attempts,
                                            gameState: gameState,
                                            hostAvatar: hostAvatar,
                                            player2Avatar: player2Avatar,
                                            hasHostPlayed: hasHostPlayed,
                                            hasPlayer2Played: hasPlayer2Played,
                                            isHost: isHost,
                                            isPlayer2: isPlayer2,
                                            isHostWinner: isHostWinner,
                                            isPlayer2Winner: isPlayer2Winner,
                                          );
                                        }
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 95,
                                      height: 95,
                                      decoration: BoxDecoration(
                                        color: matchedIndexes.contains(index)
                                            ? Colors.green.withOpacity(0.5)
                                            : const Color(0xFF1A1148),
                                        border: matchedIndexes.contains(index)
                                            ? Border.all(
                                                color: Colors.green,
                                                width: 3,
                                              )
                                            : Border.all(
                                                color: Colors.transparent,
                                                width: 2,
                                              ),
                                      ),
                                      child: Center(
                                        child: displayExOh[index] != ''
                                            ? Image.asset(
                                                displayExOh[index],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ).animate().scale(
                                                duration: const Duration(
                                                    milliseconds: 100))
                                            : const Text(''),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                              .animate(delay: const Duration(milliseconds: 400))
                              .fadeIn();
                        }),
                        const SizedBox(height: 20),
                        // Time
                        _buildTimer(
                          isRunning: isRunning,
                          winnerFound: winnerFound,
                          isHost: isHost,
                          isPlayer2: isPlayer2,
                          hasHostPlayed: hasHostPlayed,
                          hasPlayer2Played: hasPlayer2Played,
                          documentID: widget.gameId,
                          hostState: hostState,
                          player2State: player2State,
                          hostId: hostId,
                          player2Id: player2Id,
                          gameNumberId: gameNumberId,
                          hostGameId: hostGameId,
                          exTurn: exTurn,
                          ohTurn: ohTurn,
                          displayExOh: displayExOh,
                          matchedIndexes: matchedIndexes,
                          filledBoxes: filledBoxes,
                          attempts: attempts,
                          gameState: gameState,
                          hostAvatar: hostAvatar,
                          player2Avatar: player2Avatar,
                          isHostWinner: isHostWinner,
                          isPlayer2Winner: isPlayer2Winner,
                          seconds: seconds,
                        ),
                      ],
                    );
                  }
                } else if (isPlayer2) {
                  final hasPlayer2Played = player2Data['hasPlayer2Played'];
                  final hasHostPlayed = hostData['hasHostPlayed'];
                  final isHostConnected = hostData['isHostConnected'];
                  final isPlayer2Connected = player2Data['isPlayer2Connected'];
                  final hostGameId = gameData['host']['hostGameId'];
                  final gameNumberId = gameData['host']['gameNumberId'];
                  final player2Id = gameData['player2']['player2Id'];
                  final hostId = gameData['host']['hostId'];
                  final displayExOh =
                      List<String>.from(player2Data['displayExOh']);
                  final matchedIndexes =
                      List<int>.from(player2Data['matchedIndexes']);
                  final filledBoxes = player2Data['filledBoxes'];
                  attempts = player2Data['attempts'];
                  final ohTurn = player2Data['ohTurn'];
                  final exTurn = hostData['exTurn'];
                  final hostAvatar = hostData['hostAvatar'];
                  final player2Avatar = player2Data['player2Avatar'];
                  final isRunning = gameData['isRunning'];
                  final winnerFound = gameData['winnerFound'];
                  bool isHost = widget.userId == gameData['host']['hostId'];
                  bool isPlayer2 =
                      widget.userId == gameData['player2']['player2Id'];
                  final bool isHostWinner = hostData['isHostWinner'];
                  final bool isPlayer2Winner = player2Data['isPlayer2Winner'];
                  final int seconds = gameData['seconds'];

                  if (winnerFound == true && isPlayer2Winner == true) {
                    _showDialog(
                      context: context,
                      winner: 'You won',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  } else if (winnerFound == true && isHostWinner == true) {
                    _showDialog(
                      context: context,
                      winner: 'You lost',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  } else if (seconds == 0) {
                    _showDialog(
                      context: context,
                      winner: 'Time is up',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  } else if (isHostWinner && isPlayer2Winner) {
                      _clearBoard(
                        hostId: hostId,
                        gameNumberId: gameNumberId,
                        hostAvatar: hostAvatar,
                        player2Avatar: player2Avatar,
                        player2Id: player2Id,
                        hasHostPlayed: hasHostPlayed,
                        hasPlayer2Played: hasPlayer2Played,
                        isRunning: isRunning,
                        seconds: seconds,
                        gameState: gameState,
                        isHostConnected: isHostConnected,
                        isPlayer2Connected: isPlayer2Connected);
                    _showDialog(
                      context: context,
                      winner: 'Draw',
                      gameNumberId: gameNumberId,
                      filledBoxes: filledBoxes,
                      hostAvatar: hostAvatar,
                      player2Avatar: player2Avatar,
                      hostId: hostId,
                      player2Id: player2Id,
                      hasHostPlayed: hasHostPlayed,
                      hasPlayer2Played: hasPlayer2Played,
                      isHostConnected: isHostConnected,
                      isPlayer2Connected: isPlayer2Connected,
                      isRunning: isRunning,
                      gameState: true,
                      seconds: seconds,
                      checkHost: isHost,
                      checkPlayer2: isPlayer2,
                      winnerFound: winnerFound,
                    );
                  }

                  if (snapshot.data == null) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        'assets/images/background.png', // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Image.asset(
                        'assets/images/background.png', // Replace with your image asset path
                        fit: BoxFit.cover,
                      ),
                    );
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Player1Container(
                              image: hostAvatar,
                              indicator: 'assets/images/x_indicator.png',
                              isactive: exTurn,
                            ),
                            const SizedBox(width: 10),
                            Player2Container(
                              image: player2Avatar,
                              indicator: 'assets/images/o_indicator.png',
                              isactive: ohTurn,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          ohTurn ? 'It\'s Your Turn!' : 'It\'s player 2 Turn',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        )
                            .animate(autoPlay: true)
                            .fadeIn(curve: Curves.easeIn, duration: 500.ms),
                        const SizedBox(height: 20),
                        Consumer<AudioProvider>(
                            builder: (context, audio, child) {
                          return Container(
                            padding: const EdgeInsets.all(5),
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              color: const Color(0xFF29197A),
                              border: Border.all(
                                color: const Color(0xFFFDC101),
                                width: 2.5,
                              ),
                            ),
                            child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: 9,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3),
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: ohTurn
                                      ? () {
                                          audio.isSoundOn
                                              ? audio
                                                  .playSound('assets/click.wav')
                                              : '';

                                          _tapped(
                                            index: index,
                                            isRunning: isRunning,
                                            winnerFound: winnerFound,
                                            documentID: widget.gameId,
                                            hostState: hostState,
                                            player2State: player2State,
                                            exTurn: exTurn,
                                            ohTurn: ohTurn,
                                            gameNumberId: gameNumberId,
                                            hostGameId: hostGameId,
                                            hostId: hostId,
                                            player2Avatar: player2Avatar,
                                            hostAvatar: hostAvatar,
                                            player2Id: player2Id,
                                            displayExOh: displayExOh,
                                            matchedIndexes: matchedIndexes,
                                            filledBoxes: filledBoxes,
                                            attempts: attempts,
                                            gameState: gameState,
                                            hasHostPlayed: hasHostPlayed,
                                            hasPlayer2Played: hasPlayer2Played,
                                            isHost: isHost,
                                            isPlayer2: isPlayer2,
                                            isHostWinner: isHostWinner,
                                            isPlayer2Winner: isPlayer2Winner,
                                          );
                                        }
                                      : null,
                                  child: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Container(
                                      width: 95,
                                      height: 95,
                                      decoration: BoxDecoration(
                                        color: matchedIndexes.contains(index)
                                            ? Colors.green.withOpacity(0.5)
                                            : const Color.fromARGB(
                                                255, 0, 7, 38),
                                        border: matchedIndexes.contains(index)
                                            ? Border.all(
                                                color: Colors.green,
                                                width: 3,
                                              )
                                            : Border.all(
                                                color: Colors.transparent,
                                                width: 2,
                                              ),
                                      ),
                                      child: Center(
                                        child: displayExOh[index] != ''
                                            ? Image.asset(
                                                displayExOh[index],
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                              ).animate().scale(
                                                duration: const Duration(
                                                    milliseconds: 100))
                                            : const Text(''),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                              .animate(delay: const Duration(milliseconds: 400))
                              .fadeIn();
                        }),
                        const SizedBox(height: 20),
                        // Time
                        _buildTimer(
                          isRunning: isRunning,
                          winnerFound: winnerFound,
                          isHost: isHost,
                          isPlayer2: isPlayer2,
                          hasHostPlayed: hasHostPlayed,
                          hasPlayer2Played: hasPlayer2Played,
                          documentID: widget.gameId,
                          hostState: hostState,
                          player2State: player2State,
                          hostId: hostId,
                          player2Id: player2Id,
                          gameNumberId: gameNumberId,
                          hostGameId: hostGameId,
                          exTurn: exTurn,
                          ohTurn: ohTurn,
                          displayExOh: displayExOh,
                          matchedIndexes: matchedIndexes,
                          filledBoxes: filledBoxes,
                          attempts: attempts,
                          gameState: gameState,
                          hostAvatar: hostAvatar,
                          player2Avatar: player2Avatar,
                          isHostWinner: isHostWinner,
                          isPlayer2Winner: isPlayer2Winner,
                          seconds: seconds,
                        ),
                      ],
                    );
                  }
                } else if (isHost == false && isPlayer2 == false) {
                  return const NoConnectionWidget(message: 'Reconnecting...');
                }
              }
            }

            return const Text('');
          },
        ),
      ),
    );
  }

  void checkWinnerAndUpdate({
    required bool isHostWinner,
    required isPlayer2Winner,
    required bool hasHostPlayed,
    required bool hasPlayer2Played,
    required bool isHost,
    required bool isPlayer2,
    required String documentID,
    required bool hostState,
    required bool player2State,
    required bool exTurn,
    required bool ohTurn,
    required String hostAvatar,
    required String player2Avatar,
    required List<dynamic> displayExOh,
    required List<dynamic> matchedIndexes,
    required int filledBoxes,
    required int attempts,
    required String hostId,
    required String player2Id,
    required bool gameState,
    required String hostGameId,
    required String gameNumberId,
    required bool isRunning,
    required bool winnerFound,
  }) {
    updateUserStateIfNeeded(
      documentID: widget.gameId,
      hostState: hostState,
      player2State: player2State,
      exTurn: exTurn,
      ohTurn: ohTurn,
      displayExOh: displayExOh,
      matchedIndexes: matchedIndexes,
      filledBoxes: filledBoxes,
      attempts: attempts,
      gameState: gameState,
      hostId: hostId,
      hostAvatar: hostAvatar,
      player2Avatar: player2Avatar,
      player2Id: player2Id,
      hostGameId: hostGameId,
      gameNumberId: gameNumberId,
      hasHostPlayed: true,
      isRunning: isRunning,
      hasPlayer2Played: hasPlayer2Played,
      winnerFound: winnerFound,
      isHostWinner: isHostWinner,
      isPlayer2Winner: isPlayer2Winner,
    );
  }

  Widget _buildTimer({
    required bool hasHostPlayed,
    required bool hasPlayer2Played,
    required bool isHost,
    required bool isPlayer2,
    required String documentID,
    required bool hostState,
    required bool player2State,
    required bool exTurn,
    required bool ohTurn,
    required String hostAvatar,
    required String player2Avatar,
    required List<dynamic> displayExOh,
    required List<dynamic> matchedIndexes,
    required int filledBoxes,
    required int attempts,
    required String hostId,
    required String player2Id,
    required bool gameState,
    required String hostGameId,
    required String gameNumberId,
    required bool isRunning,
    required bool winnerFound,
    required bool isHostWinner,
    required bool isPlayer2Winner,
    required int seconds,
  }) {
    // final isRunning = timer == null ? false : timer!.isActive;

    if (isHost) {
      return isRunning
          ? SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1 - seconds / maxSeconds,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFF3B4FFE),
                  ),
                  Center(
                    child: Text(
                      '$seconds',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                  )
                ],
              ),
            )
          : Consumer<AudioProvider>(
              builder: (context, audio, child) {
                return PrimaryButton(
                  backgroundColor: const Color(0xFF3B4FFE),
                  title: hasHostPlayed == false && hasPlayer2Played == false
                      ? 'Play'
                      : hasHostPlayed && hasPlayer2Played == false
                          ? 'Waiting for player 2...'
                          : hasHostPlayed == false && hasPlayer2Played
                              ? 'Play'
                              : 'Start Game',
                  width: 200,
                  height: 55,
                  onpressed: () {
                    setState(() {
                      hasHostPlayed = true;
                      updateUserStateIfNeeded(
                        documentID: widget.gameId,
                        hostState: hostState,
                        player2State: player2State,
                        exTurn: exTurn,
                        ohTurn: ohTurn,
                        displayExOh: displayExOh,
                        matchedIndexes: matchedIndexes,
                        filledBoxes: filledBoxes,
                        attempts: attempts,
                        gameState: gameState,
                        hostId: hostId,
                        hostAvatar: hostAvatar,
                        player2Avatar: player2Avatar,
                        player2Id: player2Id,
                        hostGameId: hostGameId,
                        gameNumberId: gameNumberId,
                        hasHostPlayed: true,
                        isRunning: isRunning,
                        hasPlayer2Played: hasPlayer2Played,
                        winnerFound: winnerFound,
                        isHostWinner: isHostWinner,
                        isPlayer2Winner: isPlayer2Winner,
                      );
                    });

                    if (hasHostPlayed && hasPlayer2Played) {
                      audio.isSoundOn ? audio.playSound('assets/pop.wav') : '';

                      startTimer(documentID: widget.gameId);
                      updateUserStateIfNeeded(
                        isRunning: true,
                        documentID: widget.gameId,
                        hostState: hostState,
                        player2State: player2State,
                        exTurn: exTurn,
                        ohTurn: ohTurn,
                        displayExOh: displayExOh,
                        matchedIndexes: matchedIndexes,
                        filledBoxes: filledBoxes,
                        attempts: attempts,
                        gameState: gameState,
                        hostId: hostId,
                        hostAvatar: hostAvatar,
                        player2Avatar: player2Avatar,
                        player2Id: player2Id,
                        hostGameId: hostGameId,
                        gameNumberId: gameNumberId,
                        hasHostPlayed: true,
                        hasPlayer2Played: hasPlayer2Played,
                        winnerFound: winnerFound,
                        isHostWinner: isHostWinner,
                        isPlayer2Winner: isPlayer2Winner,
                      );
                    }
                  },
                  isLoading: false,
                )
                    .animate(delay: const Duration(milliseconds: 800))
                    .slideY(curve: Curves.easeIn);
              },
            );
    } else if (isPlayer2) {
      return isRunning
          ? SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1 - seconds / maxSeconds,
                    valueColor: const AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 8,
                    backgroundColor: const Color(0xFF3B4FFE),
                  ),
                  Center(
                    child: Text(
                      '$seconds',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                  )
                ],
              ),
            )
          : Consumer<AudioProvider>(
              builder: (context, audio, child) {
                return PrimaryButton(
                  backgroundColor: const Color(0xFF3B4FFE),
                  title: hasHostPlayed == false && hasPlayer2Played == false
                      ? 'Play'
                      : hasHostPlayed && hasPlayer2Played == false
                          ? 'Play'
                          : hasHostPlayed == false && hasPlayer2Played
                              ? 'Waiting for player 2...'
                              : 'Start Game',
                  width: 200,
                  height: 55,
                  onpressed: () {
                    setState(() {
                      hasPlayer2Played = true;
                      updateUserStateIfNeeded(
                        documentID: widget.gameId,
                        hostState: hostState,
                        player2State: player2State,
                        exTurn: exTurn,
                        ohTurn: ohTurn,
                        displayExOh: displayExOh,
                        matchedIndexes: matchedIndexes,
                        filledBoxes: filledBoxes,
                        attempts: attempts,
                        gameState: gameState,
                        hostId: hostId,
                        hostAvatar: hostAvatar,
                        player2Avatar: player2Avatar,
                        player2Id: player2Id,
                        hostGameId: hostGameId,
                        gameNumberId: gameNumberId,
                        hasPlayer2Played: true,
                        isRunning: isRunning,
                        hasHostPlayed: hasHostPlayed,
                        winnerFound: winnerFound,
                        isHostWinner: isHostWinner,
                        isPlayer2Winner: isPlayer2Winner,
                      );
                    });

                    if (hasHostPlayed && hasPlayer2Played) {
                      audio.isSoundOn ? audio.playSound('assets/pop.wav') : '';

                      startTimer(documentID: widget.gameId);
                      updateUserStateIfNeeded(
                        isRunning: true,
                        documentID: widget.gameId,
                        hostState: hostState,
                        player2State: player2State,
                        exTurn: exTurn,
                        ohTurn: ohTurn,
                        displayExOh: displayExOh,
                        matchedIndexes: matchedIndexes,
                        filledBoxes: filledBoxes,
                        attempts: attempts,
                        gameState: gameState,
                        hostId: hostId,
                        hostAvatar: hostAvatar,
                        player2Avatar: player2Avatar,
                        player2Id: player2Id,
                        hostGameId: hostGameId,
                        gameNumberId: gameNumberId,
                        hasHostPlayed: hasHostPlayed,
                        hasPlayer2Played: true,
                        winnerFound: winnerFound,
                        isHostWinner: isHostWinner,
                        isPlayer2Winner: isPlayer2Winner,
                      );
                    }
                  },
                  isLoading: false,
                )
                    .animate(delay: const Duration(milliseconds: 800))
                    .slideY(curve: Curves.easeIn);
              },
            );
    }

    return const Text('');
  }

  //int index, bool exTurn, bool ohTurn, int filledBoxes
  void _tapped({
    required bool hasHostPlayed,
    required bool hasPlayer2Played,
    required String documentID,
    required bool hostState,
    required bool player2State,
    required bool exTurn,
    required bool ohTurn,
    required String hostAvatar,
    required String player2Avatar,
    required List<dynamic> displayExOh,
    required List<dynamic> matchedIndexes,
    required int filledBoxes,
    required int attempts,
    required String hostId,
    required String player2Id,
    required bool gameState,
    required int index,
    required String hostGameId,
    required String gameNumberId,
    required bool isRunning,
    required bool winnerFound,
    required bool isHost,
    required bool isPlayer2,
    required bool isHostWinner,
    required bool isPlayer2Winner,
  }) {
    // final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning && displayExOh.isNotEmpty && displayExOh[index] == '') {
      setState(
        () {
          if (exTurn && ohTurn == false) {
            displayExOh[index] = 'assets/images/x_indicator.png';
          } else if (ohTurn && exTurn == false) {
            displayExOh[index] = 'assets/images/o_indicator.png';
          }
          filledBoxes += 1;
          exTurn = !exTurn;
          ohTurn = !ohTurn;

          _checkWinner(
              filledBoxes,
              hostId,
              hostAvatar,
              player2Avatar,
              player2Id,
              hasHostPlayed,
              hasPlayer2Played,
              isRunning,
              winnerFound,
              isHost,
              isPlayer2,
              isHostWinner,
              isPlayer2Winner,
              displayExOh);
          // checksIfTimerIsFinished();
          updateUserStateIfNeeded(
            documentID: widget.gameId,
            hostState: hostState,
            player2State: player2State,
            exTurn: exTurn,
            ohTurn: ohTurn,
            displayExOh: displayExOh,
            matchedIndexes: matchedIndexes,
            filledBoxes: filledBoxes,
            attempts: attempts,
            gameState: gameState,
            hostId: hostId,
            hostAvatar: hostAvatar,
            player2Avatar: player2Avatar,
            player2Id: player2Id,
            hostGameId: hostGameId,
            gameNumberId: gameNumberId,
            hasHostPlayed: hasHostPlayed,
            hasPlayer2Played: hasPlayer2Played,
            isRunning: isRunning,
            winnerFound: winnerFound,
            isHostWinner: isHostWinner,
            isPlayer2Winner: isPlayer2Winner,
          );
        },
      );
    }
  }

  void _checkWinner(
    int filledBoxes,
    String? hostId,
    String? hostAvatar,
    String? player2Avatar,
    String? player2Id,
    bool? hasHostPlayed,
    bool? hasPlayer2Played,
    bool? isRunning,
    bool? winnerFound,
    bool isHost,
    bool isPlayer2,
    bool isHostWinner,
    bool isPlayer2Winner,
    List<dynamic> displayExOh,
  ) async {
    final gameProvider = context.read<CreateGameProvider>();
    await gameProvider.calculateDiscount(widget.stake).then((value) {
      setState(() {
        wonAmount = value.toString();
      });
    });

    //checks first Row
    if (displayExOh[0] == displayExOh[1] &&
        displayExOh[0] == displayExOh[2] &&
        displayExOh[0] != '') {
      setState(() {
        matchedIndexes.addAll([0, 1, 2]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [0, 1, 2],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[0] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[0] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    }
    //checks second row
    if (displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != '') {
      setState(() {
        matchedIndexes.addAll([3, 4, 5]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [3, 4, 5],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[3] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[3] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    }
    //checks Third row
    if (displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != '') {
      setState(() {
        matchedIndexes.addAll([6, 7, 8]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [6, 7, 8],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[6] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[6] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    }
    //checks first column
    if (displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != '') {
      setState(() {
        matchedIndexes.addAll([0, 3, 6]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [0, 3, 6],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[0] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[0] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    }
    //checks second column
    if (displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != '') {
      setState(() {
        matchedIndexes.addAll([1, 4, 7]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [1, 4, 7],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[1] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[1] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    }
    //checks third column
    if (displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != '') {
      setState(() {
        matchedIndexes.addAll([2, 5, 8]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [2, 5, 8],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[2] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[2] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    }
    //checks first diagonal
    if (displayExOh[6] == displayExOh[4] &&
        displayExOh[6] == displayExOh[2] &&
        displayExOh[6] != '') {
      setState(() {
        matchedIndexes.addAll([6, 4, 2]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [6, 4, 2],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[6] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[6] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    }
    //checks second diagonal
    if (displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != '') {
      setState(() {
        matchedIndexes.addAll([0, 4, 8]);
        winnerFound == true;

        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: [0, 4, 8],
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: true,
          isHostWinner:
              displayExOh[0] == "assets/images/x_indicator.png" ? true : false,
          isPlayer2Winner:
              displayExOh[0] == "assets/images/o_indicator.png" ? true : false,
        );
        stopTimer();
      });
    } else if (winnerFound == false && filledBoxes == 9) {
      setState(() {
        updateUserStateIfNeeded(
          documentID: widget.gameId,
          hostState: hostState,
          player2State: player2State,
          exTurn: exTurn,
          ohTurn: ohTurn,
          displayExOh: displayExOh,
          matchedIndexes: matchedIndexes,
          filledBoxes: filledBoxes,
          attempts: attempts,
          gameState: gameState,
          hostId: hostId,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          player2Id: player2Id,
          hostGameId: hostGameId,
          gameNumberId: gameNumberId,
          hasHostPlayed: hasHostPlayed,
          hasPlayer2Played: hasPlayer2Played,
          isRunning: isRunning,
          winnerFound: false,
          isHostWinner: true,
          isPlayer2Winner: true,
        );
        stopTimer();
      });
    }
  }

  void _showDialog({
    required BuildContext context,
    required String winner,
    required String gameNumberId,
    required int filledBoxes,
    required String hostAvatar,
    required String player2Avatar,
    required String hostId,
    required String player2Id,
    required bool hasHostPlayed,
    required bool hasPlayer2Played,
    required bool isHostConnected,
    required bool isPlayer2Connected,
    required bool isRunning,
    required bool gameState,
    required int seconds,
    required bool checkHost,
    required bool checkPlayer2,
    required bool winnerFound,
  }) async {
    final firestore = context.read<FireStoreServiceProvider>();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (winner == 'You won' && checkHost) {
          AudioProvider audioProvider = AudioProvider();
          if (audioProvider.isSoundOn) {
            audioProvider.playSound('assets/cheering.mp3');
          } else {
            '';
          }

          handleWinnerBalance(checkPlayer2);
          stopTimer();
          return WinnerDailog(
            wonAmount: wonAmount,
            onPressed: () async {
              await firestore.deleteGame(widget.gameId);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return const MainPage();
                  },
                ),
              );
            },
          );
        } else if (winner == 'You won' && checkPlayer2) {
          AudioProvider audioProvider = AudioProvider();
          if (audioProvider.isSoundOn) {
            audioProvider.playSound('assets/cheering.mp3');
          } else {
            '';
          }

          handleWinnerBalance(checkPlayer2);
          stopTimer();
          return WinnerDailog(
            wonAmount: wonAmount,
            onPressed: () async {
              await firestore.deleteGame(widget.gameId);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return const MainPage();
                  },
                ),
              );
            },
          );
        } else if (winner == 'Draw') {
          return OtherDailog(
            text: 'IT\'S A DRAW! ',
            smallText: 'play again till the time runs out',
            buttonText: 'Play again',
            onPressed: () {
              startTimer(documentID: widget.gameId);
              Navigator.pop(context);
            },
          );
        } else if (winner == 'Time is up') {
          return OtherDailog(
            text: 'TIME IS UP!',
            smallText: 'Your account has been refunded.',
            buttonText: 'Go home',
            onPressed: () async {
              handleRefund(checkHost).then(
                (value) => firestore.deleteGame(widget.gameId).then(
                      (value) => Navigator.pushReplacement(
                        context,
                        CupertinoPageRoute(
                          builder: (context) {
                            return const MainPage();
                          },
                        ),
                      ),
                    ),
              );
            },
          );
        } else if (winner == 'You lost' && checkHost) {
          handleLooserBalance(checkHost);
          stopTimer();
          return OtherDailog(
            text: 'YOU LOST',
            smallText: 'Better luck next time.',
            buttonText: 'Go home',
            onPressed: () async {
              await firestore.deleteGame(widget.gameId);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return const MainPage();
                  },
                ),
              );
            },
          );
        } else if (winner == 'You lost' && checkPlayer2) {
          handleLooserBalance(checkHost);
          stopTimer();
          return OtherDailog(
            text: 'YOU LOST',
            smallText: 'Better luck next time',
            buttonText: 'Go home',
            onPressed: () async {
              await firestore.deleteGame(widget.gameId);
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return const MainPage();
                  },
                ),
              );
            },
          );
        }
        return const Text('');
      },
    );
  }

  Future<void> _clearBoard({
    required String hostId,
    required String gameNumberId,
    required String hostAvatar,
    required String player2Avatar,
    required String player2Id,
    required bool hasHostPlayed,
    required bool hasPlayer2Played,
    required bool isRunning,
    required int seconds,
    required bool gameState,
    required bool isHostConnected,
    required bool isPlayer2Connected,
  }) async {
    final firestore = context.read<FireStoreServiceProvider>();
    await firestore.resetGame(
      gameId: widget.gameId,
      hostId: hostId,
      gameNumberId: gameNumberId,
      player2Id: player2Id,
      exTurn: false,
      ohTurn: true,
      displayExOh: List.filled(9, ''),
      matchedIndexes: [],
      filledBoxes: 0,
      attempts: 1,
      seconds: seconds,
      hostAvatar: hostAvatar,
      player2Avatar: player2Avatar,
      gameState: gameState,
      stake: widget.stake,
      isHostConnected: isHostConnected,
      isPlayer2Connected: isPlayer2Connected,
      hasHostPlayed: hasHostPlayed,
      hasPlayer2Played: hasPlayer2Played,
      isRunning: true,
      winnerFound: false,
      isHostWinner: false,
      isPlayer2Winner: false,
    );
  }

  // refund
  Future handleRefund(bool checkHost) async {
    final gameProvider = context.read<CreateGameProvider>();
    final firestore = context.read<FireStoreServiceProvider>();
    //internet provider
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else if (checkHost) {
      await gameProvider
          .calcUserWinBalance(
        context,
        widget.coin,
        widget.stake.toInt(),
      )
          .then(
        (value) async {
          await gameProvider
              .deleteGame(
                context,
                hostGameId,
                gameNumberId,
              )
              .then((value) => firestore.deletePendingRequest(hostGameId!));
        },
      );
    } else {
      await gameProvider
          .deleteGame(
            context,
            hostGameId,
            gameNumberId,
          )
          .then((value) => firestore.deletePendingRequest(hostGameId!));
    }
  }

  //Winner Dailog
  Future handleWinnerBalance(bool checkPlayer2) async {
    final gameProvider = context.read<CreateGameProvider>();
    final firestore = context.read<FireStoreServiceProvider>();
    //internet provider
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else if (!checkPlayer2) {
      await gameProvider.calculateDiscount(widget.stake).then((value) async {
        await gameProvider
            .calcUserWinBalance(
          context,
          widget.coin,
          value.toInt(),
        )
            .then(
          (value) async {
            await gameProvider
                .deleteGame(
                  context,
                  hostGameId,
                  gameNumberId,
                )
                .then((value) => firestore.deletePendingRequest(hostGameId!));
          },
        );
      });
    } else {
      await gameProvider.calculateDiscount(widget.stake).then((value) async {
        await gameProvider
            .calcUserWinBalance(
          context,
          widget.coin - widget.stake.toInt(),
          value.toInt(),
        )
            .then(
          (value) async {
            await gameProvider
                .deleteGame(
                  context,
                  hostGameId,
                  gameNumberId,
                )
                .then((value) => firestore.deletePendingRequest(hostGameId!));
          },
        );
      });
    }
  }

  Future handleLooserBalance(bool checkHost) async {
    final gameProvider = context.read<CreateGameProvider>();
    final firestore = context.read<FireStoreServiceProvider>();
    //internet provider
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else if (!checkHost) {
      await gameProvider
          .calcUserLostBalance(
        context,
        widget.stake,
        double.parse(
          widget.coin.toString(),
        ),
      )
          .then(
        (value) async {
          await gameProvider
              .deleteGame(
                context,
                hostGameId,
                gameNumberId,
              )
              .then((value) => firestore.deletePendingRequest(hostGameId!));
        },
      );
    } else {
      await gameProvider
          .deleteGame(
            context,
            hostGameId,
            gameNumberId,
          )
          .then((value) => firestore.deletePendingRequest(hostGameId!));
    }
  }
}
