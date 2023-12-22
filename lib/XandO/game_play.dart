import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/XandO/components/player_container.dart';
import 'package:xando/components/primary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class XandOGameScreen extends StatefulWidget {
  const XandOGameScreen({super.key});

  @override
  State<XandOGameScreen> createState() => _XandOGameScreenState();
}

class _XandOGameScreenState extends State<XandOGameScreen> {
  // Add a reference to your Firestore collection
  final CollectionReference gamesCollection =
      FirebaseFirestore.instance.collection('games');

  bool exTurn = true; //The first Player is O
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

  Timer? timer;
  static const maxSeconds = 60;
  int seconds = maxSeconds;

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

  void resetTimer() => seconds = maxSeconds;

  // Update the method to update game state in Firestore
  Future<void> updateGameState(String gameId) async {
    await gamesCollection.doc(gameId).set({
      'exTurn': exTurn,
      'displayExOh': displayExOh,
      'matchedIndexes': matchedIndexes,
      'filledBoxes': filledBoxes,
      'attempts': attempts,
      'seconds': seconds,
    });
  }

// Add a method to get real-time updates from Firestore
  Stream<DocumentSnapshot> getGameStream(String gameId) {
    return gamesCollection.doc(gameId).snapshots();
  }

  @override
  Widget build(BuildContext context) {
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
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.volume_up,
                    ),
                  ),
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
                        '200000.00',
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Player1Container(
                    image: 'assets/images/scott_brown.png',
                    indicator: 'assets/images/x_indicator.png',
                    isactive: exTurn,
                  ),
                  const SizedBox(width: 10),
                  Player2Container(
                    image: 'assets/images/profile_pic.png',
                    indicator: 'assets/images/o_indicator.png',
                    isactive: exTurn,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                exTurn ? 'It\'s Your Turn!' : 'It\'s Player 2 Turn',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(5),
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 32, 40, 73),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 9,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      onTap: () {
                        _tapped(index);
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
                                  )
                                : const Text(''),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Time
              _buildTimer(),
            ],
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
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
        _checkWinner();
      });
    }
  }

  void _checkWinner() {
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

  void _showDrawDialog() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Its a Draw'),
            actions: [
              TextButton(
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
                },
                child: const Text('Play again'),
              ),
            ],
          );
        });
  }

  void _showDialog(String winner) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('winner is : $winner'),
            actions: [
              TextButton(
                onPressed: () {
                  _clearBoard();
                  Navigator.of(context).pop();
                },
                child: const Text('Play again'),
              ),
            ],
          );
        });
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
        : PrimaryButton(
            title: attempts == 0 ? 'Start' : 'Replay',
            width: 200,
            height: 55,
            onpressed: () {
              startTimer();
            },
            isLoading: false,
          );
  }
}
