import 'package:flutter/cupertino.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/models/home_screen_model.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/reusable_widgets/banner_pageview.dart';
import 'package:xando/reusable_widgets/reusable_appbar.dart';
import 'package:xando/screens/Main_Screens/game_details_screen.dart';
import 'package:xando/utils/game_requests_enums.dart';
import 'package:xando/utils/snackbar_message.dart';
import 'package:rive/rive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<List<AvailableGamesModel>> _streamController =
      StreamController.broadcast();

  late int _coin;
  late HomePageModel _model;
  late Timer _timer;
  late String _userId;
  late String _username;
  late String _deviceToken;
  double potentialWin = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _loadUserData() async {
    int? coin = await DatabaseProvider().getCoin();
    String? userId = await DatabaseProvider().getUserId();
    String? deviceToken = await DatabaseProvider().getDeviceToken();
    String? username = await DatabaseProvider().getUserName();
    if (mounted) {
      setState(() {
        _userId = userId;
        _coin = coin;
        _deviceToken = deviceToken;
        _username = username;
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
    _model = createModel(context, () => HomePageModel());

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        getAvailableGames();
      } else {
        // Ensure that the timer is canceled when the widget is disposed
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  Future<void> getAvailableGames() async {
    final getGames = context.read<GetAvailableGamesProvider>();
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();

    if (internetProvider.hasInternet == false) {
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
        message: 'Internet connection not available.',
        context: context,
        status: false,
      );
    } else {
      await getGames.getAvailableGames().then((value) {
        if (getGames.hasError == true) {
          showErrorSnackBarMessage(
            message: getGames.resMessage,
            context: context,
            status: false,
          );
        } else {
          setState(() {
            _streamController.sink.add(getGames.availableGames);
          });
        }
      });
    }
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

  //Firebase Cloud Messaging for Push Notifications

  @override
  Widget build(BuildContext context) {
    if (isiOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarBrightness: Theme.of(context).brightness,
          systemStatusBarContrastEnforced: true,
        ),
      );
    }

    return GestureDetector(
      onTap: () => _model.unfocusNode.canRequestFocus
          ? FocusScope.of(context).requestFocus(_model.unfocusNode)
          : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(136), // Set this height
          child: ReusableAppBar(
            coin: _coin,
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 150,
                child: SizedBox(
                  width: double.infinity,
                  height: 500,
                  child: BannerPageViewBuilder(),
                ),
              ),
            ),
            StreamBuilder<List<AvailableGamesModel>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<AvailableGamesModel> filteredGames = snapshot.data!
                      .where((game) => game.user?.id != _userId)
                      .toList();

                  if (filteredGames.isNotEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(13, 0, 13, 15),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  'Available Games',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                Container(
                                  width: 15,
                                  height: 15,
                                  decoration: const BoxDecoration(),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/fire_emoji.png',
                                      width: 300,
                                      height: 200,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            filteredGames.length > 10
                                ? Text(
                                    'Show(${filteredGames.length})',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: const Color(0xFFB1B1B1),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  )
                                : const Text(''),
                          ],
                        ),
                      ),
                    );
                  }
                }
                return SliverToBoxAdapter(child: Container());
              },
            ),
            StreamBuilder<List<AvailableGamesModel>>(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return SliverToBoxAdapter(
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height / 2,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3B4FFE),
                        ),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return SliverToBoxAdapter(
                      child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  List<AvailableGamesModel> filteredGames = snapshot.data!
                      .where((game) => game.user?.id != _userId)
                      .toList();

                  //.
                  if (filteredGames.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              'No Available Games Yet',
                              style: TextStyle(
                                fontFamily: 'Regular',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: FutureBuilder<UserModel>(
                                future:
                                    EditProfileProvider().getUserProfileData(),
                                builder: (context, snapshot) {
                                  return GameCard(
                                    onCardTap: () {
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) =>
                                                  GameDetailsScreen(
                                                    receiverAvatar:
                                                        filteredGames[index]
                                                            .user
                                                            ?.avatar,
                                                    senderAvatar:
                                                        snapshot.data?.avatar,
                                                    receiverDeviceToken:
                                                        filteredGames[index]
                                                            .user
                                                            ?.deviceToken,
                                                    senderUsername: _username,
                                                    senderDeviceToken:
                                                        _deviceToken,
                                                    state: filteredGames[index]
                                                        .state,
                                                    receiverId:
                                                        filteredGames[index]
                                                            .user
                                                            ?.id,
                                                    senderId: _userId,
                                                    stake: filteredGames[index]
                                                        .stake,
                                                    potentialWin:
                                                        filteredGames[index]
                                                            .stake!,
                                                    gameTitle:
                                                        filteredGames[index]
                                                            .title,
                                                    gameId: filteredGames[index]
                                                        .gameId,
                                                    username:
                                                        filteredGames[index]
                                                            .user
                                                            ?.username,
                                                  )));
                                    },
                                    image: filteredGames[index].user?.avatar ??
                                        'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                    username:
                                        filteredGames[index].user?.username,
                                    price: filteredGames[index].stake,
                                    buttonText: filteredGames[index].state!
                                        ? 'Join'
                                        : 'Unavailble',
                                    state: filteredGames[index].state!,
                                    onTap: () {
                                      _showCustomDialog(
                                        context: context,
                                        stake: filteredGames[index].stake,
                                        gameId: filteredGames[index].gameId,
                                        username:
                                            filteredGames[index].user?.username,
                                        receiverId:
                                            filteredGames[index].user?.id,
                                        senderId: _userId,
                                        senderUsername: _username,
                                        senderDeviceToken: _deviceToken,
                                        receiverDeviceToken:
                                            filteredGames[index]
                                                .user
                                                ?.deviceToken,
                                        receiverAvatar: filteredGames[index]
                                                .user
                                                ?.avatar ??
                                            'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                        senderAvatar: snapshot.data?.avatar ??
                                            'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                      );
                                    },
                                    cardColor:
                                        const Color.fromARGB(255, 15, 22, 44),
                                  );
                                }),
                          );
                        },
                        childCount: filteredGames.length > 10
                            ? 10
                            : filteredGames.length,
                      ),
                    );
                  }
                }
                return SliverToBoxAdapter(child: Container());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCustomDialog({
    required BuildContext context,
    required String? stake,
    required String? gameId,
    required String? username,
    required String? senderUsername,
    required String? receiverId,
    required String? senderId,
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
                                  print('receiver $receiverId');
                                  await game
                                      .updateGameState(false, receiverId)
                                      .then((value) async {
                                    await firestoreService
                                        .addGameRequest(
                                      senderId,
                                      receiverId,
                                      senderDeviceToken,
                                      receiverDeviceToken,
                                      username,
                                      gameId,
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
