import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/XandO/components/board_tile.dart';
import 'package:xando/XandO/components/player_container.dart';

class XandOGameScreen extends StatefulWidget {
  const XandOGameScreen({super.key});

  @override
  State<XandOGameScreen> createState() => _XandOGameScreenState();
}

class _XandOGameScreenState extends State<XandOGameScreen> {
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

  int filledBoxes = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(-1.20, -0.70),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/Union.png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.2, -0.50),
                child: Container(
                  width: 55,
                  height: 55,
                  decoration: const BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/Exclude.png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(-0.95, 0.33),
                child: Container(
                  width: 110,
                  height: 110,
                  decoration: const BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/Exclude_(1).png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
                      alignment: const Alignment(-1.00, 0.00),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: const AlignmentDirectional(1.00, 0.10),
                child: Container(
                  width: 78.56,
                  height: 78.56,
                  decoration: const BoxDecoration(),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/Union_(1).png',
                      width: 300,
                      height: 200,
                      fit: BoxFit.contain,
                      alignment: const Alignment(1.00, 0.00),
                    ),
                  ),
                ),
              ),
              Column(
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
                  const SizedBox(height: 30),
                  Text(
                    exTurn ? 'It\'s Your Turn!' : 'It\'s Player 2 Turn',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 24,
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
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3),
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onTap: () {
                            _tapped(index);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: BoardTile(
                              displayExOh: displayExOh,
                              index: index,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tapped(int index) {
    setState(() {
      if (exTurn && displayExOh[index] == '') {
        displayExOh[index] = 'assets/images/x_3d.png';
        filledBoxes += 1;
      } else if (!exTurn && displayExOh[index] == '') {
        displayExOh[index] = 'assets/images/o_3d.png';
        filledBoxes += 1;
      }
      exTurn = !exTurn;
      _checkWinner();
    });
  }

  void _checkWinner() {
    //checks first Row
    if (displayExOh[0] == displayExOh[1] &&
        displayExOh[0] == displayExOh[2] &&
        displayExOh[0] != '') {
      _showDialog(displayExOh[0]);
    }
    //checks second row
    if (displayExOh[3] == displayExOh[4] &&
        displayExOh[3] == displayExOh[5] &&
        displayExOh[3] != '') {
      _showDialog(displayExOh[3]);
    }
    //checks Third row
    if (displayExOh[6] == displayExOh[7] &&
        displayExOh[6] == displayExOh[8] &&
        displayExOh[6] != '') {
      _showDialog(displayExOh[6]);
    }
    //checks first column
    if (displayExOh[0] == displayExOh[3] &&
        displayExOh[0] == displayExOh[6] &&
        displayExOh[0] != '') {
      _showDialog(displayExOh[0]);
    }
    //checks second column
    if (displayExOh[1] == displayExOh[4] &&
        displayExOh[1] == displayExOh[7] &&
        displayExOh[1] != '') {
      _showDialog(displayExOh[1]);
    }
    //checks third column
    if (displayExOh[2] == displayExOh[5] &&
        displayExOh[2] == displayExOh[8] &&
        displayExOh[2] != '') {
      _showDialog(displayExOh[2]);
    }
    //checks first diagonal
    if (displayExOh[6] == displayExOh[4] &&
        displayExOh[6] == displayExOh[2] &&
        displayExOh[6] != '') {
      _showDialog(displayExOh[6]);
    }
    //checks second diagonal
    if (displayExOh[0] == displayExOh[4] &&
        displayExOh[0] == displayExOh[8] &&
        displayExOh[0] != '') {
      _showDialog(displayExOh[0]);
    } else if (filledBoxes == 9) {
      _showDrawDialog();
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
}
