import 'package:flutter/cupertino.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/affliate_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/Providers/snackbar_provider.dart';
import 'package:xando/XandO/create_a_game.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/models/home_screen_model.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/reusable_widgets/banner_pageview.dart';
import 'package:xando/reusable_widgets/reusable_appbar.dart';
import 'package:xando/screens/Finance_Screens/wallet_screen.dart';
import 'package:xando/screens/Main_Screens/game_details_screen.dart';
import 'package:xando/screens/Main_Screens/showall_games.dart';
import 'package:xando/utils/game_requests_enums.dart';
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

  int _coin = 0;
  late HomePageModel _model;
  late Timer _timer;
  String _userId = '';
  String _username = '';
  String _deviceToken = '';
  String _userAvatar = 'https://api.multiavatar.com/5b1271f9320afc278a.png';
  double potentialWin = 0;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _loadUserData() async {
    final profile = context.read<AffliateProvider>();

    await profile.getUserProfileDataForHomeScreen().then((value) {
      if (mounted) {
        setState(() {
          _coin = value.gamedata!.coin;
          _deviceToken = value.deviceToken!;
          _userId = value.id!;
          _username = value.username!;
          _userAvatar = value.avatar!;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();

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

    await getGames.getAvailableGames().then((value) {
      if (getGames.hasError == true) {
      } else {
        setState(() {
          _streamController.sink.add(getGames.availableGames);
        });
      }
    });
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
      child: FutureBuilder(
          future: Future.wait([
            FireStoreServiceProvider().getRequestsStreamForUser(_userId).first,
            FireStoreServiceProvider().getRequestsStreamByUser(_userId).first,
          ]),
          builder: (context,
              AsyncSnapshot<List<List<Map<String, dynamic>>>> snapshot) {
            bool isDataAvailable =
                snapshot.data?.any((list) => list.isNotEmpty) ?? false;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Provider.of<PointerSnackbarProvider>(context, listen: false)
                  .toggleVisibility(isDataAvailable);
            });
            List<Map<String, dynamic>> requests = [];
            if (snapshot.hasData) {
              final data = snapshot.data!;
              for (var streamData in data) {
                requests.addAll(streamData);
              }
            } else {
              requests = [];
            }
            return Scaffold(
              key: scaffoldKey,
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(
                      isDataAvailable ? 144 + 55 : 144), // Set this height
                  child: ReusableAppBar(
                    requests: requests,
                    isDataAvailable: isDataAvailable,
                    userId: _userId,
                    coin: _coin,
                  )),
              body: CustomScrollView(
                physics: const ClampingScrollPhysics(),
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
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  13, 0, 13, 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      ),
                                      Container(
                                        width: 15,
                                        height: 15,
                                        decoration: const BoxDecoration(),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                      ? GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        ShowAllGames(
                                                          filteredGames:
                                                              filteredGames,
                                                          senderAvatar:
                                                              _userAvatar,
                                                          userId: _userId,
                                                          username: _username,
                                                          deviceToken:
                                                              _deviceToken,
                                                        )));
                                          },
                                          child: Text(
                                            'Show All (${filteredGames.length})',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  fontFamily:
                                                      'Plus Jakarta Sans',
                                                  color:
                                                      const Color(0xFFB1B1B1),
                                                  fontSize: 11,
                                                  fontWeight: FontWeight.bold,
                                                  useGoogleFonts: GoogleFonts
                                                          .asMap()
                                                      .containsKey(
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMediumFamily),
                                                ),
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
                          return SliverToBoxAdapter(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/tic-tac-toe_black.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'No available games yet',
                                    style: TextStyle(
                                      fontFamily: 'Bold',
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    'Don\'t worry when there are \ngames available, it will  appear here. \nYou can also create a game to get \nstarted.',
                                    style: TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 20),
                                  SecondaryButton(
                                      title: '+ Create Game',
                                      width: 180,
                                      height: 50,
                                      onpressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const CreateGameScreen()));
                                      },
                                      isLoading: false),
                                ],
                              ).animate().fadeIn(duration: 500.ms),
                            ),
                          );
                        } else {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13),
                                  child: FutureBuilder<UserModel>(
                                      future: EditProfileProvider()
                                          .getUserProfileData(),
                                      builder: (context, snapshot) {
                                        return GameCard(
                                          onCardTap: () {
                                            Navigator.push(
                                                context,
                                                CupertinoPageRoute(
                                                    builder: (context) =>
                                                        GameDetailsScreen(
                                                          idOfgame:
                                                              filteredGames[
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                          receiverAvatar:
                                                              filteredGames[
                                                                          index]
                                                                      .user
                                                                      ?.avatar ??
                                                                  'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                                          senderAvatar: snapshot
                                                                  .data
                                                                  ?.avatar ??
                                                              'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                                          receiverDeviceToken:
                                                              filteredGames[
                                                                      index]
                                                                  .user
                                                                  ?.deviceToken,
                                                          senderUsername:
                                                              _username,
                                                          senderDeviceToken:
                                                              _deviceToken,
                                                          state: filteredGames[
                                                                  index]
                                                              .state,
                                                          receiverId:
                                                              filteredGames[
                                                                      index]
                                                                  .user
                                                                  ?.id,
                                                          senderId: _userId,
                                                          stake: filteredGames[
                                                                  index]
                                                              .stake,
                                                          potentialWin:
                                                              filteredGames[
                                                                      index]
                                                                  .stake!,
                                                          gameTitle:
                                                              filteredGames[
                                                                      index]
                                                                  .title,
                                                          gameId: filteredGames[
                                                                  index]
                                                              .gameId,
                                                          username:
                                                              filteredGames[
                                                                      index]
                                                                  .user
                                                                  ?.username,
                                                        )));
                                          },
                                          image: filteredGames[index]
                                                  .user
                                                  ?.avatar ??
                                              'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                          username: filteredGames[index]
                                              .user
                                              ?.username,
                                          price: filteredGames[index].stake,
                                          buttonText:
                                              filteredGames[index].state!
                                                  ? 'Join'
                                                  : 'Unavailble',
                                          state: filteredGames[index].state!,
                                          onTap: () {
                                            _showCustomDialog(
                                              context: context,
                                              stake: filteredGames[index].stake,
                                              gameId:
                                                  filteredGames[index].gameId,
                                              idOfGame: filteredGames[index].id,
                                              username: filteredGames[index]
                                                  .user
                                                  ?.username,
                                              receiverId:
                                                  filteredGames[index].user?.id,
                                              senderId: _userId,
                                              senderUsername: _username,
                                              senderDeviceToken: _deviceToken,
                                              receiverDeviceToken:
                                                  filteredGames[index]
                                                      .user
                                                      ?.deviceToken,
                                              receiverAvatar: filteredGames[
                                                          index]
                                                      .user
                                                      ?.avatar ??
                                                  'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                              senderAvatar: snapshot
                                                      .data?.avatar ??
                                                  'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                            );
                                          },
                                          cardColor: const Color.fromARGB(
                                              255, 15, 22, 44),
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
            );
          }),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Container(
                    width: 35,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 73, 84, 129),
                      borderRadius: BorderRadius.circular(50),
                    ),
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
