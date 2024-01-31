import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/XandO/game_loading_screen.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';

class UserRequests extends StatefulWidget {
  const UserRequests({
    super.key,
    required this.username,
    required this.requestTime,
    required this.gameID,
    required this.stake,
    required this.status,
    required this.profileAvatar,
    required this.documentID,
    required this.gameNumberId,
  });

  final String username;
  final String requestTime;
  final String gameID;
  final String gameNumberId;
  final String stake;
  final String status;
  final String profileAvatar;
  final String documentID;

  @override
  State<UserRequests> createState() => _UserRequestsState();
}

class _UserRequestsState extends State<UserRequests> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: Image.network(
                  widget.profileAvatar,
                ).image,
              ),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.username,
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                    ),
                    // Text(
                    //   'You requested to join',
                    //   style: TextStyle(
                    //     fontFamily: 'Medium',
                    //     fontSize: 12,
                    //     color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                    //   ),
                    // ),
                    Text(
                      widget.requestTime,
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Game ID: ${widget.gameID}',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                      ),
                    ),
                    Text(
                      'Stake: ${widget.stake}',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                      ),
                    ),
                    const Text(
                      '',
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                FutureBuilder(
                    future: FireStoreServiceProvider()
                        .readDocument(widget.documentID),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Map<String, dynamic>? documentData = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryButton(
                              backgroundColor: documentData != null
                                  ? documentData['status'] ==
                                          'RequestStatus.accepted'
                                      ? Colors.green
                                      : documentData['status'] ==
                                              'RequestStatus.declined'
                                          ? const Color(0xFF7B7B7B)
                                          : const Color(0xFF7B7B7B)
                                  : const Color(0xFF7B7B7B),
                              title: documentData != null
                                  ? documentData['status'] ==
                                          'RequestStatus.accepted'
                                      ? 'Play'
                                      : documentData['status'] ==
                                              'RequestStatus.declined'
                                          ? 'Declined'
                                          : 'Pending'
                                  : 'Pending',
                              width: 120,
                              height: 29,
                              onpressed: documentData?['status'] !=
                                      'RequestStatus.accepted'
                                  ? null
                                  : () {
                                      if (documentData?['status'] ==
                                          'RequestStatus.accepted') {
                                        startGame(
                                          documentData?['receiverDeviceToken'],
                                          documentData?['receiverAvatar'],
                                          documentData?['senderAvatar'],
                                          documentData?['gameID'],
                                          documentData?['gameNumberId'],
                                          documentData?['receiverId'],
                                          documentData?['senderId'],
                                          true,
                                          double.parse(documentData?['stake']),
                                        );
                                      }
                                    },
                              isLoading: false,
                            ),
                            const SizedBox(width: 8),
                            Consumer<FireStoreServiceProvider>(
                                builder: (context, firestore, child) {
                              final game =
                                  Provider.of<GetAvailableGamesProvider>(
                                      context,
                                      listen: false);
                              return SecondaryButton(
                                title: 'Delete',
                                width: 120,
                                height: 29,
                                onpressed: () async {
                                  await firestore
                                      .deletePendingRequest(widget.documentID)
                                      .then((value) => game.updateGameState(
                                          true, widget.gameNumberId));
                                },
                                isLoading: firestore.isLoading,
                              );
                            }),
                          ],
                        );
                      } else {
                        return const Text('');
                      }
                    }),
              ],
            ),
          )
        ],
      ),
    );
  }

  //start game
  startGame(
    String receiverDeviceToken,
    String hostAvatar,
    player2Avatar,
    String gameId,
    String gameNumberId,
    String hostId,
    String player2Id,
    bool state,
    double stake,
  ) async {
    final firestore = context.read<FireStoreServiceProvider>();

    await firestore
        .sendNotification(
            receiverDeviceToken,
            'Game Alert',
            'Your of game ID: $gameId is about to start, click to join now',
            widget.profileAvatar)
        .then(
      (value) async {
        await firestore
            .connectPlayersToGame(
          gameNumberId: gameNumberId,
          gameId: gameId,
          exTurn: true,
          ohTurn: false,
          displayExOh: List.filled(9, ''),
          matchedIndexes: [],
          filledBoxes: 0,
          attempts: 0,
          seconds: 60,
          hostAvatar: hostAvatar,
          player2Avatar: player2Avatar,
          hostId: hostId,
          player2Id: player2Id,
          stake: stake,
          gameState: state,
          isHostConnected: true,
          isPlayer2Connected: true,
          hasHostPlayed: false,
          hasPlayer2Played: false,
        )
            .then(
          (value) {
            Navigator.pushReplacement(context, CupertinoPageRoute(
              builder: (context) {
                return GameLoadingScreen(gameId: gameId, stake: stake);
              },
            ));
          },
        );
      },
    );
  }
}
