import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/utils/game_requests_enums.dart';

// ignore: must_be_immutable
class GameDetailsScreen extends StatefulWidget {
  GameDetailsScreen({
    super.key,
    required this.state,
    required this.stake,
    required this.potentialWin,
    required this.gameTitle,
    required this.gameId,
    required this.username,
    required this.senderUsername,
    required this.senderId,
    required this.receiverId,
    required this.receiverDeviceToken,
    required this.receiverAvatar,
    required this.senderAvatar,
    required this.senderDeviceToken,
  });

  final String? stake;
  String potentialWin;
  final String? gameTitle;
  final String? gameId;
  final String? username;
  final String? senderUsername;
  final String? senderId;
  final String? receiverId;
  final bool? state;
  final String? receiverDeviceToken;
  final String? senderDeviceToken;
  final String? senderAvatar;
  final String? receiverAvatar;

  @override
  State<GameDetailsScreen> createState() => _GameDetailsScreenState();
}

class _GameDetailsScreenState extends State<GameDetailsScreen> {
  double? calculateDiscount(double stake) {
    // Calculate the sum of the two equal numbers
    double sum = 2 * stake;

    // Calculate 20% off the sum
    double discount = 0.20 * sum;

    // Calculate the final discounted value
    double discountedValue = sum - discount;

    return discountedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Set this height
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 13.0,
              left: 13,
              top: 50,
              bottom: 20,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Row(
                children: [
                  const Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Game Details',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              Text(
                widget.state! ? 'Join this game' : 'Unavailable',
                style: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'Bold',
                ),
              ),
              const SizedBox(height: 7),
              Text(
                widget.state!
                    ? 'Send a request to the owner of this game, \nwe will notify you when it has been \naccepted.'
                    : 'This game seem to be ongoing or \nunavailable.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Medium',
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '${widget.username}',
                    style: const TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Stake',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    'NGN ${widget.stake}',
                    style: const TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Potential win',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    'NGN ${calculateDiscount(double.parse(widget.potentialWin)).toString()}',
                    style: const TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Title',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '${widget.gameTitle}',
                    style: const TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Game ID',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '${widget.gameId}',
                    style: const TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SecondaryButton(
                    title: 'Cancel',
                    width: MediaQuery.of(context).size.width / 2.5,
                    height: 50,
                    onpressed: () {
                      Navigator.pop(context);
                    },
                    isLoading: false,
                  ),
                  Consumer<FireStoreServiceProvider>(
                      builder: (context, firestoreService, child) {
                    final game = Provider.of<GetAvailableGamesProvider>(context,
                        listen: false);
                    return PrimaryButton(
                      backgroundColor: const Color(0xFF3B4FFE),
                      title: widget.state! ? 'Proceed' : 'Unavailable',
                      width: MediaQuery.of(context).size.width / 2.5,
                      height: 50,
                      onpressed: widget.state!
                          ? () async {
                              await game
                                  .updateGameState(false, widget.receiverId)
                                  .then((value) async {
                                await firestoreService
                                    .addGameRequest(
                                  widget.senderId,
                                  widget.receiverId,
                                  widget.senderDeviceToken,
                                  widget.receiverDeviceToken,
                                  widget.username,
                                  widget.gameId,
                                  widget.stake,
                                  widget.senderUsername,
                                  widget.receiverAvatar,
                                  widget.senderAvatar,
                                  RequestStatus.pending,
                                )
                                    .then((value) async {
                                  await firestoreService
                                      .sendNotification(
                                    widget.receiverDeviceToken,
                                    'Game Request',
                                    '${widget.username} wants to join your game',
                                    widget.senderAvatar ??
                                        'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                  )
                                      .then((value) {
                                    Navigator.pop(context);
                                    _showJoinGameBottomSheet(
                                      context: context,
                                      stake: widget.stake,
                                      gameId: widget.gameId,
                                      potentialWin: calculateDiscount(
                                              double.parse(widget.stake!))
                                          .toString(),
                                    );
                                  });
                                });
                              });
                            }
                          : null,
                      isLoading: firestoreService.isLoading,
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showJoinGameBottomSheet({
    required BuildContext context,
    required String? stake,
    required String? gameId,
    required String? potentialWin,
  }) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 16, 20, 37),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Container(
                  width: 35,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 73, 84, 129),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(height: 16.0),
                const SizedBox(
                  width: 130,
                  height: 100,
                  child: RiveAnimation.asset(
                    'assets/images/success.riv',
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  'Request Sent',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Bold',
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  'Your request to join this game has \nbeen sent successfully!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Medium',
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stake',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      'NGN ${stake!}',
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Potential win',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      potentialWin!,
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Game ID',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      gameId!,
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  backgroundColor: const Color(0xFF3B4FFE),
                  title: 'Close',
                  width: double.infinity,
                  height: 50,
                  onpressed: () {
                    Navigator.pop(context);
                  },
                  isLoading: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
