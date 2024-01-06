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
  bool shouldUpdateUserState = false;
  bool hostState = true;
  bool player2State = true;

  void updateUserStateIfNeeded({
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
      );
    }
  }

  bool exTurn = true;
  bool ohTurn = false;
  bool checkHost = false;
  bool checkPlayer2 = false;
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
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          _showDialog("Time is up", filledBoxes, '', '', '', '');
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() => seconds = maxSeconds;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  (snapshot.error as FirebaseException).code == 'unavailable') {
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
                  (snapshot.error as FirebaseException).code == 'unavailable') {
                shouldUpdateUserState = true;
                hostState = true;
                player2State = false;
                return const NoConnectionWidget(
                  message: 'Player2 has lost connection. \nPlease wait.',
                );
              }
            } else {
              if (isHost) {
                final hostGameId = gameData['host']['hostGameId'];
                final gameNumberId = gameData['host']['gameNumberId'];
                final player2Id = gameData['player2']['player2Id'];
                final hostId = gameData['host']['hostId'];
                final hostAvatar = hostData['hostAvatar'];
                final player2Avatar = player2Data['player2Avatar'];
                displayExOh = List<String>.from(hostData['displayExOh']);
                matchedIndexes = List<int>.from(hostData['matchedIndexes']);
                filledBoxes = hostData['filledBoxes'];
                attempts = hostData['attempts'];
                checkHost = true;
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
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    )
                        .animate(autoPlay: true)
                        .fadeIn(curve: Curves.easeIn, duration: 500.ms),
                    const SizedBox(height: 20),
                    Consumer<AudioProvider>(builder: (context, audio, child) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        width: 300,
                        height: 300,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 32, 40, 73),
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
                                          ? audio.playSound('assets/pop.wav')
                                          : '';
                                      _tapped(
                                        index: index,
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
                                        : const Color.fromARGB(255, 0, 7, 38),
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
                    _buildTimer(),
                  ],
                );
              } else if (isPlayer2) {
                final hostGameId = gameData['host']['hostGameId'];
                final gameNumberId = gameData['host']['gameNumberId'];
                final player2Id = gameData['player2']['player2Id'];
                final hostId = gameData['host']['hostId'];
                displayExOh = List<String>.from(player2Data['displayExOh']);
                matchedIndexes = List<int>.from(player2Data['matchedIndexes']);
                filledBoxes = player2Data['filledBoxes'];
                attempts = player2Data['attempts'];
                final ohTurn = player2Data['ohTurn'];
                final exTurn = hostData['exTurn'];
                final hostAvatar = hostData['hostAvatar'];
                final player2Avatar = player2Data['player2Avatar'];

                checkPlayer2 = true;

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
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    )
                        .animate(autoPlay: true)
                        .fadeIn(curve: Curves.easeIn, duration: 500.ms),
                    const SizedBox(height: 20),
                    Consumer<AudioProvider>(builder: (context, audio, child) {
                      return Container(
                        padding: const EdgeInsets.all(5),
                        width: 300,
                        height: 300,
                        decoration: const BoxDecoration(
                          color: Color.fromARGB(255, 32, 40, 73),
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
                                          ? audio.playSound('assets/pop.wav')
                                          : '';

                                      _tapped(
                                        index: index,
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
                                        : const Color.fromARGB(255, 0, 7, 38),
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
                    _buildTimer(),
                  ],
                );
              } else if (isHost == false && isPlayer2 == false) {
                return const NoConnectionWidget(message: 'Reconnecting...');
              }
            }
          }

          return const Text('');
        },
      ),
    );
  }

  Widget _buildTimer() {
    final isRunning = timer == null ? false : timer!.isActive;

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
        : Consumer<AudioProvider>(builder: (context, audio, child) {
            return PrimaryButton(
              backgroundColor: const Color(0xFF3B4FFE),
              title: attempts == 0 ? 'Start' : 'Replay',
              width: 200,
              height: 55,
              onpressed: () {
                audio.isSoundOn ? audio.playSound('assets/pop.wav') : '';
                startTimer();
              },
              isLoading: false,
            )
                .animate(delay: const Duration(milliseconds: 800))
                .slideY(curve: Curves.easeIn);
          });
  }

  //int index, bool exTurn, bool ohTurn, int filledBoxes
  void _tapped({
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
  }) {
    final isRunning = timer == null ? false : timer!.isActive;

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
          );
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
        );
        stopTimer();
        _showDialog(
          displayExOh[0],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
    //checks second row
    if (displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != '') {
      setState(() {
        matchedIndexes.addAll([3, 4, 5]);
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
        );
        stopTimer();
        _showDialog(
          displayExOh[3],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
    //checks Third row
    if (displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != '') {
      setState(() {
        matchedIndexes.addAll([6, 7, 8]);
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
        );
        stopTimer();
        _showDialog(
          displayExOh[6],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
    //checks first column
    if (displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != '') {
      setState(() {
        matchedIndexes.addAll([0, 3, 6]);
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
        );
        stopTimer();
        _showDialog(
          displayExOh[0],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
    //checks second column
    if (displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != '') {
      setState(() {
        matchedIndexes.addAll([1, 4, 7]);
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
        );
        stopTimer();
        _showDialog(
          displayExOh[1],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
    //checks third column
    if (displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != '') {
      setState(() {
        matchedIndexes.addAll([2, 5, 8]);
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
        );
        stopTimer();
        _showDialog(
          displayExOh[2],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
    //checks first diagonal
    if (displayExOh[6] == displayExOh[4] &&
        displayExOh[6] == displayExOh[2] &&
        displayExOh[6] != '') {
      setState(() {
        matchedIndexes.addAll([6, 4, 2]);
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
        );
        stopTimer();
        _showDialog(
          displayExOh[6],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
    //checks second diagonal
    if (displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != '') {
      setState(() {
        matchedIndexes.addAll([0, 4, 8]);
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
        );
        stopTimer();
        _showDialog(
          displayExOh[0],
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    } else if (filledBoxes == 9) {
      setState(() {
        attempts++;
        stopTimer();
        _showDialog(
          'Draw',
          filledBoxes,
          hostAvatar,
          player2Avatar,
          hostId,
          player2Id,
        );
      });
    }
  }

  void _showDialog(
    String winner,
    int filledBoxes,
    String? hostAvatar,
    String? player2Avatar,
    String? hostId,
    String? player2Id,
  ) async {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (winner == 'assets/images/x_indicator.png' && checkHost) {
          AudioProvider audioProvider = AudioProvider();
          if (audioProvider.isSoundOn) {
            audioProvider.playSound('assets/cheering.mp3');
          } else {
            '';
          }

          handleWinnerBalance();
          return WinnerDailog(
            wonAmount: wonAmount,
            onPressed: () async {
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
        } else if (winner == 'assets/images/o_indicator.png' && checkHost) {
          handleLooserBalance();
          return OtherDailog(
            text: 'YOU LOST',
            smallText: '',
            buttonText: 'Go home',
            onPressed: () async {
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
        } else if (winner == 'assets/images/o_indicator.png' && checkPlayer2) {
          AudioProvider audioProvider = AudioProvider();
          if (audioProvider.isSoundOn) {
            audioProvider.playSound('assets/cheering.mp3');
          } else {
            '';
          }

          handleWinnerBalance();
          return WinnerDailog(
            wonAmount: wonAmount,
            onPressed: () async {
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
        } else if (winner == 'assets/images/x_indicator.png' && checkPlayer2) {
          handleLooserBalance();
          return OtherDailog(
            text: 'YOU LOST',
            smallText: '',
            buttonText: 'Go home',
            onPressed: () async {
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
              _clearBoard(
                displayExOh,
                matchedIndexes,
                filledBoxes,
                !exTurn,
                !ohTurn,
                hostId,
                hostAvatar,
                player2Avatar,
                player2Id,
              );
              Navigator.of(context).pop();
            },
          );
        } else if (winner == 'Time is up') {
          handleRefund();
          return OtherDailog(
            text: 'TIME IS UP!',
            smallText: 'Your account has been refunded.',
            buttonText: 'Go home',
            onPressed: () async {
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
        } else {
          return const Text('');
        }
      },
    );
  }

  void _clearBoard(
    List<dynamic> displayExOh,
    List<dynamic> matchedIndexes,
    int filledBoxes,
    bool exTurn,
    bool ohTurn,
    String? hostId,
    String? hostAvatar,
    String? player2Avatar,
    String? player2Id,
  ) {
    setState(() {
      updateUserStateIfNeeded(
        documentID: widget.gameId,
        hostState: hostState,
        player2State: player2State,
        exTurn: false,
        ohTurn: true,
        displayExOh: List.filled(9, ''),
        matchedIndexes: [],
        filledBoxes: 0,
        attempts: attempts++,
        gameState: gameState,
        hostId: hostId,
        hostAvatar: hostAvatar,
        player2Avatar: player2Avatar,
        player2Id: player2Id,
        hostGameId: hostId,
        gameNumberId: gameNumberId,
      );
    });
  }

  // refund
  Future handleRefund() async {
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
  Future handleWinnerBalance() async {
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

  Future handleLooserBalance() async {
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
