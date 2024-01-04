import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/XandO/game_loading_screen.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/utils/game_requests_enums.dart';
import 'package:xando/utils/routers.dart';

class PendingRequests extends StatefulWidget {
  const PendingRequests({
    super.key,
    required this.senderUsername,
    required this.requestTime,
    required this.gameID,
    required this.stake,
    required this.status,
    required this.profileAvatar,
    required this.documentID,
    required this.gameNumberId,
    required this.username,
    required this.receiverAvatar,
  });

  final String senderUsername;
  final String requestTime;
  final String gameID;
  final String stake;
  final String status;
  final String profileAvatar;
  final String receiverAvatar;
  final String documentID;
  final String gameNumberId;
  final String username;

  @override
  State<PendingRequests> createState() => _PendingRequestsState();
}

class _PendingRequestsState extends State<PendingRequests> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.senderUsername,
                        style: const TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        'Requested to join',
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                        ),
                      ),
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
                        widget.gameID,
                        style: TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5).withOpacity(0.5),
                        ),
                      ),
                      Text(
                        widget.stake,
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
                  FutureBuilder<dynamic>(
                    future: FireStoreServiceProvider()
                        .readDocument(widget.documentID),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // Now you can use documentData safely
                        Map<String, dynamic>? documentData = snapshot.data;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            PrimaryButton(
                              title: documentData!['status'] ==
                                      'RequestStatus.accepted'
                                  ? 'Play'
                                  : 'Accept',
                              width: 120,
                              height: 29,
                              onpressed: () {
                                if (documentData['status'] ==
                                    'RequestStatus.accepted') {
                                  startGame(
                                    documentData['senderDeviceToken'],
                                    documentData['receiverAvatar'],
                                    documentData['senderAvatar'],
                                    documentData['gameID'],
                                    documentData['gameNumberId'],
                                    documentData['receiverId'],
                                    documentData['senderId'],
                                    true,
                                    double.parse(documentData['stake']),
                                  );
                                } else {
                                  requestAccepted(
                                      documentData['senderDeviceToken']);
                                }
                              },
                              isLoading: false,
                              backgroundColor: documentData['status'] ==
                                      'RequestStatus.accepted'
                                  ? Colors.green
                                  : const Color(0xFF3B4FFE),
                            ),
                            const SizedBox(width: 8),
                            SecondaryButton(
                              title: documentData['status'] ==
                                      'RequestStatus.accepted'
                                  ? 'Accepted'
                                  : 'Decline',
                              width: 120,
                              height: 29,
                              onpressed: documentData['status'] ==
                                      'RequestStatus.accepted'
                                  ? null
                                  : () {
                                      requestDeclined();
                                    },
                              isLoading: false,
                            ),
                          ],
                        );
                      } else {
                        return const Text('');
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  //
  requestDeclined() async {
    final firestore = context.read<FireStoreServiceProvider>();
    final game = context.read<GetAvailableGamesProvider>();
    await firestore
        .updatePendingRequest(widget.documentID, RequestStatus.declined)
        .then((value) async {
      await firestore.deletePendingRequest(widget.documentID).then((value) {
        game.updateGameState(true, widget.gameNumberId);
      });
    });
  }

  requestAccepted(String senderDeviceToken) async {
    final firestore = context.read<FireStoreServiceProvider>();
    await firestore
        .updatePendingRequest(widget.documentID, RequestStatus.accepted)
        .then((value) async {
      await firestore.sendNotification(
        senderDeviceToken,
        'Game Request Accepted',
        'your request to join ${widget.username} has been accepted',
        widget.receiverAvatar,
      );
    });
  }

  //start game
  startGame(
    String senderDeviceToken,
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
            senderDeviceToken,
            'Game Alert',
            'Your request was accepted and a game with ${widget.username} is about to start click to join',
            widget.receiverAvatar)
        .then(
      (value) async {
        await firestore
            .connectPlayersToGame(
          gameId: gameId,
          gameNumberId: gameNumberId,
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
