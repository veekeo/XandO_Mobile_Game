import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/audio_provider.dart';
import 'package:xando/Providers/Game/create_game_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/XandO/components/all_dailog.dart';
import 'package:xando/XandO/components/player_container.dart';
import 'package:xando/XandO/components/winner_dailog.dart';
import 'package:xando/components/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:xando/main_page.dart';
import 'package:xando/utils/snackbar_message.dart';

class XandOGameScreen extends StatefulWidget {
  const XandOGameScreen({
    super.key,
    required this.gameId,
    required this.stake,
  });

  final String gameId;
  final double stake;

  @override
  State<XandOGameScreen> createState() => _XandOGameScreenState();
}

class _XandOGameScreenState extends State<XandOGameScreen> {
  late String _userId;
  late int _coin;
  _loadUserData() async {
    int? coin = await DatabaseProvider().getCoin();
    String? userId = await DatabaseProvider().getUserId();

    if (mounted) {
      setState(() {
        _userId = userId;
        _coin = coin;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userId = '';
    _coin = 0;
    _loadUserData();
  }

  bool exTurn = true;
  bool ohTurn = false;
  bool checkHost = false;
  bool checkPlayer2 = false;

  List<String> displayExOh = [
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

  int seconds = 0;

  //Timer Function
  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          stopTimer();
        }
      });
    });
  }

  void stopTimer() {
    timer?.cancel();
  }

  void resetTimer() => seconds;

  Future updateUserState(bool hostState, bool player2State) async {
    final firestore = context.read<FireStoreServiceProvider>();
    await firestore.updateUserState(widget.gameId, hostState, player2State);
  }

  @override
  Widget build(BuildContext context) {
    final isSoundOn =
        Provider.of<AudioProvider>(context, listen: true).isSoundOn;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<AudioProvider>(builder: (context, audio, child) {
                    return IconButton(
                      onPressed: () {
                        audio.toggleSound();
                      },
                      icon: isSoundOn
                          ? const Icon(
                              Icons.volume_up,
                            )
                          : const Icon(
                              Icons.volume_off,
                            ),
                    );
                  }),
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/images/game_interface_logo.png',
                    width: 100,
                    height: 35,
                    fit: BoxFit.contain,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFF2BD02),
                        size: 18,
                      ),
                      Text(
                        _coin.toString(),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: FireStoreServiceProvider().getGameStream(widget.gameId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                updateUserState(false, false);
                return const NoConnectionWidget(message: 'Reconnecting...');
              }

              if (!snapshot.hasData) {
                updateUserState(false, false);
                return const NoConnectionWidget(
                    message: 'Loading... \nPlease wait');
              }
              final hostData = snapshot.data?['host'];
              final player2Data = snapshot.data?['player2'];
              gameState = snapshot.data?['state'];
              final gameData = snapshot.data!.data() as Map<String, dynamic>;
              seconds = gameData['seconds'];

              //

              exTurn = gameData['host']['exTurn'];
              ohTurn = gameData['player2']['ohTurn'];
              final hostId = gameData['host']['hostId'];
              final player2Id = gameData['player2']['player2Id'];

              // Check if the current user is the host or player2
              bool isHost = _userId == hostId;
              bool isPlayer2 = _userId == player2Id;
              if (snapshot.hasError && _userId == hostId) {
                updateUserState(false, true);

                if (snapshot.error is FirebaseException &&
                    (snapshot.error as FirebaseException).code ==
                        'unavailable') {
                  return const NoConnectionWidget(
                    message: 'Player2 has lost connection. Please wait.',
                  );
                }
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasError && _userId == player2Id) {
                updateUserState(true, false);
                if (snapshot.error is FirebaseException &&
                    (snapshot.error as FirebaseException).code ==
                        'unavailable') {
                  return const NoConnectionWidget(
                    message: 'Player2 has lost connection. Please wait.',
                  );
                }
              } else {
                updateUserState(true, true);
              }

              if (isHost) {
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
                          image: hostData['hostAvatar'],
                          indicator: 'assets/images/x_indicator.png',
                          isactive: exTurn,
                        ),
                        const SizedBox(width: 10),
                        Player2Container(
                          image: hostData['player2Avatar'],
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
                    ),
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
                              onTap: () {
                                audio.isSoundOn
                                    ? audio.playSound('assets/pop.wav')
                                    : '';
                                _tapped(index, exTurn, filledBoxes);
                              },
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
                displayExOh = List<String>.from(player2Data['displayExOh']);
                matchedIndexes = List<int>.from(player2Data['matchedIndexes']);
                filledBoxes = player2Data['filledBoxes'];
                attempts = player2Data['attempts'];

                checkHost = true;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Player1Container(
                          image: player2Data['hostAvatar'],
                          indicator: 'assets/images/x_indicator.png',
                          isactive: exTurn,
                        ),
                        const SizedBox(width: 10),
                        Player2Container(
                          image: player2Data['player2Avatar'],
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
                    ),
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
                              onTap: () {
                                audio.isSoundOn
                                    ? audio.playSound('assets/pop.wav')
                                    : '';
                                _tapped(index, exTurn, filledBoxes);
                              },
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
              }
              return const Text('');
            },
          ),
        ),
      ),
    );
  }

  void _tapped(int index, bool exTurn, int filledBoxes) {
    final isRunning = timer == null ? false : timer!.isActive;

    if (isRunning) {
      setState(() {
        if (exTurn && displayExOh[index] == '') {
          displayExOh[index] = 'assets/images/x_indicator.png';
          filledBoxes += 1;
        } else if (!exTurn && displayExOh[index] == '') {
          displayExOh[index] = 'assets/images/o_indicator.png';
          filledBoxes += 1;
        }
        exTurn = !exTurn;
        ohTurn = !ohTurn;
        _checkWinner();
        checksIfTimerIsFinished();
      });
    }
  }

  void _checkWinner() async {
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
        stopTimer();
        _showDialog(displayExOh[0]);
      });
    }
    //checks second row
    if (displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != '') {
      setState(() {
        matchedIndexes.addAll([3, 4, 5]);
        stopTimer();
        _showDialog(displayExOh[3]);
      });
    }
    //checks Third row
    if (displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != '') {
      setState(() {
        matchedIndexes.addAll([6, 7, 8]);
        stopTimer();
        _showDialog(displayExOh[6]);
      });
    }
    //checks first column
    if (displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != '') {
      setState(() {
        matchedIndexes.addAll([0, 3, 6]);
        stopTimer();
        _showDialog(displayExOh[0]);
      });
    }
    //checks second column
    if (displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != '') {
      setState(() {
        matchedIndexes.addAll([1, 4, 7]);
        stopTimer();
        _showDialog(displayExOh[1]);
      });
    }
    //checks third column
    if (displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != '') {
      setState(() {
        matchedIndexes.addAll([2, 5, 8]);
        stopTimer();
        _showDialog(displayExOh[2]);
      });
    }
    //checks first diagonal
    if (displayExOh[6] == displayExOh[4] &&
        displayExOh[6] == displayExOh[2] &&
        displayExOh[6] != '') {
      setState(() {
        matchedIndexes.addAll([6, 4, 2]);
        stopTimer();
        _showDialog(displayExOh[6]);
      });
    }
    //checks second diagonal
    if (displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != '') {
      setState(() {
        matchedIndexes.addAll([0, 4, 8]);
        stopTimer();
        _showDialog(displayExOh[0]);
      });
    } else if (filledBoxes == 9) {
      setState(() {
        attempts++;
        print(attempts);
        stopTimer();
        _showDrawDialog();
      });
    }
  }

  void checksIfTimerIsFinished() {
    if (seconds >= 60) {
      _showDialog('Time is Up');
    }
  }

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return OtherDailog(
              text: 'It\'s a draw!',
              onPressed: () {
                _clearBoard();
                Navigator.of(context).pop();
              },
              buttonText: 'Play Again');
        });
  }

  void _showDialog(String winner) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        if (winner == 'assets/images/x_indicator.png' && checkHost) {
          return WinnerDailog(
            wonAmount: wonAmount,
            onPressed: () async {
              await handleWinnerBalance().then((value) =>
                  Navigator.pushReplacement(context,
                      CupertinoPageRoute(builder: (context) {
                    return MainPage();
                  })));
            },
          );
        } else if (winner == 'assets/images/o_indicator.png' && checkHost) {
          return OtherDailog(
            text: 'YOU LOST',
            buttonText: 'Go home',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return MainPage();
                  },
                ),
              );
            },
          );
        } else if (winner == 'assets/images/o_indicator.png' && checkPlayer2) {
          return WinnerDailog(
            wonAmount: wonAmount,
            onPressed: () async {
              await handleWinnerBalance().then(
                (value) => Navigator.pushReplacement(
                  context,
                  CupertinoPageRoute(
                    builder: (context) {
                      return MainPage();
                    },
                  ),
                ),
              );
            },
          );
        } else if (winner == 'assets/images/x_indicator.png' && checkPlayer2) {
          return OtherDailog(
            text: 'YOU LOST',
            buttonText: 'Go home',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return MainPage();
                  },
                ),
              );
            },
          );
        } else {
          return OtherDailog(
            text: 'TIME IS UP! \n You have been refunded',
            buttonText: 'Go home',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                CupertinoPageRoute(
                  builder: (context) {
                    return MainPage();
                  },
                ),
              );
            },
          );
        }
      },
    );
  }

  void _clearBoard() {
    setState(() {
      for (int i = 0; i < 9; i++) {
        displayExOh[i] = '';
      }
      filledBoxes = 0;
    });
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
                  value: 1 - seconds.toDouble(),
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

  //Winner Dailog
  Future handleWinnerBalance() async {
    final gameProvider = context.read<CreateGameProvider>();
    //internet provider
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else {
      await gameProvider.calculateDiscount(widget.stake).then((value) async {
        await gameProvider.calcUserWinBalance(context, _coin, value.toInt());
      });
    }
  }

  Future handleLooserBalance() async {
    final gameProvider = context.read<CreateGameProvider>();
    //internet provider
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else {
      // ignore: use_build_context_synchronously
      await gameProvider.calcUserLostBalance(
          context, widget.stake, double.parse(_coin.toString()));
    }
  }
}

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 100,
              width: 100,
              child: RiveAnimation.asset(
                'assets/images/loader.riv',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Bold',
                fontSize: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
