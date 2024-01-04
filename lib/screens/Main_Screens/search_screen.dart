import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/screens/Finance_Screens/deposit_screen.dart';
import 'package:xando/screens/Finance_Screens/wallet_screen.dart';
import 'package:xando/screens/Main_Screens/game_details_screen.dart';
import 'package:xando/utils/game_requests_enums.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String _userId;
  late String _deviceToken;
  late String _username;
  double potentialWin = 0;
  late int _coin;
  _loadUserData() async {
    String? userId = await DatabaseProvider().getUserId();
    String? deviceToken = await DatabaseProvider().getDeviceToken();
    String? username = await DatabaseProvider().getUserName();
    int? coin = await DatabaseProvider().getCoin();
    if (mounted) {
      setState(() {
        _userId = userId;
        _deviceToken = deviceToken;
        _username = username;
        _coin = coin;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userId = '';
    _deviceToken = '';
    _username = '';
    _coin = 0;
    _loadUserData();
  }

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
    final getGamesProvider = Provider.of<GetAvailableGamesProvider>(context);
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
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
              child: SizedBox(
                width: double.infinity,
                child: TextFormField(
                  // controller: _model.textController,
                  // focusNode: _model.textFieldFocusNode,
                  onChanged: (query) {
                    getGamesProvider.searchGamesByQuery(query);
                  },
                  autofocus: true,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: 'Accounts,Games, Game ID',
                    hintStyle: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 14,
                          color: const Color(0x4DFFFFFF),
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: FlutterFlowTheme.of(context).error,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    contentPadding:
                        const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      color: Color(0x4DFFFFFF),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 14.0),
                        child: Text(
                          'Cancel',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 14,
                                color: const Color(0xB1FFFFFF),
                                fontWeight: FontWeight.normal,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                      ),
                    ),
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  // validator: _model.textControllerValidator.asValidator(context),
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          children: [
            if (getGamesProvider.isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF3B4FFE),
                ),
              )
            else if (getGamesProvider.searchedGames == [])
              const Text('')
            else
              Expanded(
                child: ListView.builder(
                  itemBuilder: (context, index) {
                    List<AvailableGamesModel> filteredGames = getGamesProvider
                        .searchedGames
                        .where((game) => game.user?.id != _userId)
                        .toList();

                    final game = filteredGames.length > index
                        ? filteredGames[index]
                        : null;

                    if (game != null) {
                      return FutureBuilder<UserModel>(
                          future: EditProfileProvider().getUserProfileData(),
                          builder: (context, snapshot) {
                            return GameCard(
                              onCardTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (context) => GameDetailsScreen(
                                              idOfgame: game.id.toString(),
                                              senderAvatar: snapshot
                                                      .data?.avatar ??
                                                  'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                              senderUsername: _username,
                                              receiverAvatar: game
                                                      .user?.avatar ??
                                                  'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                              receiverDeviceToken:
                                                  game.user?.deviceToken,
                                              state: game.state,
                                              receiverId: game.user?.id,
                                              senderId: _userId,
                                              stake: game.stake,
                                              potentialWin: game.stake!,
                                              gameTitle: game.title,
                                              gameId: game.gameId,
                                              username: game.user?.username,
                                              senderDeviceToken: _deviceToken,
                                            )));
                              },
                              image: game.user?.avatar ??
                                  'https://api.multiavatar.com/5b1271f9320afc278a.png',
                              username: game.user?.username,
                              price: game.stake,
                              buttonText: game.state! ? 'Join' : 'Unavailable',
                              state: game.state!,
                              onTap: () {
                                _showCustomDialog(
                                  context: context,
                                  stake: game.stake,
                                  gameId: game.gameId,
                                  username: game.user?.username,
                                  receiverId: game.user?.id,
                                  senderId: _userId,
                                  senderDeviceToken: _deviceToken,
                                  receiverDeviceToken: game.user?.deviceToken,
                                  receiverAvatar: game.user?.avatar ??
                                      'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                  senderAvatar: snapshot.data?.avatar ??
                                      'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                  senderUsername: _username,
                                  idOfGame: game.id,
                                );
                              },
                              cardColor: const Color.fromARGB(255, 15, 22, 44),
                            );
                          });
                    } else {
                      return const Text('');
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showInsufficientDailog() {
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
                  'There is not enough balance in your \naccount to join this game',
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
                                          '$username wants to join your game',
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
                                    Navigator.pop(context);
                                    _showInsufficientDailog();
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
