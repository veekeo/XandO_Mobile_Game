import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/screens/Finance_Screens/wallet_screen.dart';
import 'package:xando/screens/Main_Screens/game_details_screen.dart';
import 'package:xando/utils/game_requests_enums.dart';

class ShowAllGames extends StatefulWidget {
  const ShowAllGames({
    super.key,
    required this.filteredGames,
    required this.senderAvatar,
    required this.userId,
    required this.username,
    required this.deviceToken,
  });

  final List<AvailableGamesModel> filteredGames;
  final String senderAvatar;
  final String userId;
  final String username;
  final String deviceToken;

  @override
  State<ShowAllGames> createState() => _ShowAllGamesState();
}

class _ShowAllGamesState extends State<ShowAllGames> {
  double potentialWin = 0;

  double calculateDiscount(double stake) {
    // Calculate the sum of the two equal numbers
    double sum = 2 * stake;

    // Calculate 20% off the sum
    double discount = 0.20 * sum;

    // Calculate the final discounted value
    double discountedValue = sum - discount;
    setState(() {
      potentialWin = discountedValue;
    });

    return potentialWin;
  }

  bool _checkifUserBalanceIsSufficient(int balance, int stake) {
    if (balance >= stake) {
      return true;
    } else {
      return false;
    }
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
                    'All games',
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
        child: ListView.builder(
          itemCount: widget.filteredGames.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: GameCard(
                onCardTap: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          builder: (context) => GameDetailsScreen(
                                idOfgame:
                                    widget.filteredGames[index].id.toString(),
                                receiverAvatar: widget
                                        .filteredGames[index].user?.avatar ??
                                    'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                senderAvatar: widget.senderAvatar,
                                receiverDeviceToken: widget
                                    .filteredGames[index].user?.deviceToken,
                                senderUsername: widget.username,
                                senderDeviceToken: widget.deviceToken,
                                state: widget.filteredGames[index].state,
                                receiverId:
                                    widget.filteredGames[index].user?.id,
                                senderId: widget.userId,
                                stake: widget.filteredGames[index].stake,
                                potentialWin:
                                    widget.filteredGames[index].stake!,
                                gameTitle: widget.filteredGames[index].title,
                                gameId: widget.filteredGames[index].gameId,
                                username:
                                    widget.filteredGames[index].user?.username,
                              )));
                },
                image: widget.filteredGames[index].user?.avatar ??
                    'https://api.multiavatar.com/5b1271f9320afc278a.png',
                username: widget.filteredGames[index].user?.username,
                price: widget.filteredGames[index].stake,
                buttonText:
                    widget.filteredGames[index].state! ? 'Join' : 'Unavailble',
                state: widget.filteredGames[index].state!,
                onTap: () {
                  _showCustomDialog(
                    context: context,
                    stake: widget.filteredGames[index].stake,
                    gameId: widget.filteredGames[index].gameId,
                    idOfGame: widget.filteredGames[index].id,
                    username: widget.filteredGames[index].user?.username,
                    receiverId: widget.filteredGames[index].user?.id,
                    senderId: widget.userId,
                    senderUsername: widget.username,
                    senderDeviceToken: widget.deviceToken,
                    receiverDeviceToken:
                        widget.filteredGames[index].user?.deviceToken,
                    receiverAvatar: widget.filteredGames[index].user?.avatar ??
                        'https://api.multiavatar.com/5b1271f9320afc278a.png',
                    senderAvatar: widget.senderAvatar,
                  );
                },
                cardColor: const Color.fromARGB(255, 15, 22, 44),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showInsufficientDailog(
    BuildContext context,
  ) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: const Color.fromARGB(255, 32, 40, 73),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 15),
                const Text(
                  'Balance Insufficient',
                  style: TextStyle(
                    fontFamily: 'Bold',
                    fontSize: 20,
                  ),
                ),
                Text(
                  'There is not enough balance in your account to join this game',
                  style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5)),
                ),
              ],
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Later',
                  style: TextStyle(
                    fontFamily: 'Bold',
                    fontSize: 16,
                    color: Color(0xFF3B4FFE),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      CupertinoPageRoute(builder: (context) {
                    return const WalletScreen(selectedTabFromExternalRoute: 0);
                  }));
                },
                child: const Text(
                  'Deposit',
                  style: TextStyle(
                    fontFamily: 'Bold',
                    fontSize: 16,
                    color: Color(0xFF3B4FFE),
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _showCustomDialog({
    required BuildContext context,
    required String? stake,
    required String? gameId,
    required String? username,
    required String? senderUsername,
    required String? receiverId,
    required String? senderId,
    required int? idOfGame,
    required String? receiverDeviceToken,
    required String? receiverAvatar,
    required String? senderAvatar,
    required String? senderDeviceToken,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Stack(
          children: [
            // Background overlay
            Positioned.fill(
              child: Container(
                color: Colors.black54,
              ),
            ),
            Positioned(
              top: 50,
              left: 50,
              bottom: 50,
              right: 50,
              child: Center(
                child: Container(
                  height: 270,
                  width: 450,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 32, 40, 73),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Join Game',
                          style: TextStyle(
                            fontFamily: 'Bold',
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          'Are you sure you want to send a \nrequest to join this game?',
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
                        const SizedBox(height: 15),
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
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Host',
                              style: TextStyle(
                                fontFamily: 'Medium',
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.5),
                              ),
                            ),
                            Text(
                              username!,
                              style: const TextStyle(
                                fontFamily: 'Medium',
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SecondaryButton(
                              title: 'Cancel',
                              width: 110,
                              height: 35,
                              onpressed: () {
                                Navigator.pop(context);
                              },
                              isLoading: false,
                            ),
                            Consumer<FireStoreServiceProvider>(
                                builder: (context, firestoreService, child) {
                              final game =
                                  Provider.of<GetAvailableGamesProvider>(
                                      context,
                                      listen: false);

                              return PrimaryButton(
                                backgroundColor: const Color(0xFF3B4FFE),
                                title: 'Proceed',
                                width: 110,
                                height: 35,
                                onpressed: () async {
                                  final profileCoinProvider =
                                      context.read<EditProfileProvider>();
                                  var userProfileData =
                                      await profileCoinProvider
                                          .getUserProfileData();
                                  if (_checkifUserBalanceIsSufficient(
                                      userProfileData.gamedata!.coin,
                                      double.parse(stake).toInt())) {
                                    await game
                                        .updateGameState(
                                            false, idOfGame.toString())
                                        .then((value) async {
                                      await firestoreService
                                          .addGameRequest(
                                        senderId,
                                        receiverId,
                                        senderDeviceToken,
                                        receiverDeviceToken,
                                        username,
                                        gameId,
                                        idOfGame.toString(),
                                        stake,
                                        senderUsername,
                                        receiverAvatar,
                                        senderAvatar,
                                        RequestStatus.pending,
                                      )
                                          .then((value) async {
                                        await firestoreService
                                            .sendNotification(
                                          receiverDeviceToken,
                                          'Game Request',
                                          '$senderUsername wants to join your game',
                                          senderAvatar,
                                        )
                                            .then((value) {
                                          Navigator.pop(context);
                                          _showJoinGameBottomSheet(
                                            context: context,
                                            stake: stake,
                                            gameId: gameId,
                                            potentialWin: calculateDiscount(
                                                    double.parse(stake))
                                                .toString(),
                                          );
                                        });
                                      });
                                    });
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    Navigator.pop(context);
                                    // ignore: use_build_context_synchronously
                                    _showInsufficientDailog(context);
                                  }
                                },
                                isLoading: firestoreService.isLoading,
                              );
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
