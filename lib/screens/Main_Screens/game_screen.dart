// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/XandO/create_a_game.dart';
import 'package:xando/components/currency_balance_container.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/components/tabs.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/models/game_screen_model.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/screens/Main_Screens/user_game_details_screen.dart';
import 'package:xando/utils/dynamic_links.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({
    super.key,
    required this.selectedTabFromExternalRoute,
    this.gameData,
    this.userData,
  });
  final int selectedTabFromExternalRoute;
  final List<AvailableGamesModel>? gameData;
  final UserModel? userData;

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameScreenModel _model;
  int _selectedIndex = 0;
  late String _userId;
  late int _userCoin;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _updateIfFromExternalRoute() {
    setState(() {
      _selectedIndex = widget.selectedTabFromExternalRoute;
    });
  }

  @override
  void initState() {
    super.initState();
    _userId = '';
    _userCoin = 0;
    _loadUserData();
    _getUserCoinBalance();
    _updateIfFromExternalRoute();
    _model = createModel(context, () => GameScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();
    widget.selectedTabFromExternalRoute;
    super.dispose();
  }

  _loadUserData() async {
    String? userId = await DatabaseProvider().getUserId();
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  _getUserCoinBalance() async {
    int coin = await DatabaseProvider().getCoin().then((value) {
      return value;
    });
    if (mounted) {
      setState(() {
        _userCoin = coin;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(150), // Set this height
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Games',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                      FutureBuilder<UserModel>(
                        future: EditProfileProvider().getUserProfileData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CurrencyBalanceContainer(
                              coin: _userCoin.toString(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CurrencyBalanceContainer(
                              coin: '${snapshot.data!.gamedata?.coin}',
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FirstTab(
                          selectedTab: () {
                            _onTabSelected(0);
                          },
                          isSelected: _selectedIndex == 0,
                          tabTitle: 'Open Games',
                        ),
                        SecondTab(
                          selectedTab: () {
                            _onTabSelected(1);
                          },
                          isSelected: _selectedIndex == 1,
                          tabTitle: 'History',
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 2,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 35, 37, 60),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _selectedIndex == 0
            ? OpenGames(
                userId: _userId,
                gameData: widget.gameData,
              )
            : History(),
      ),
    );
  }
}

class OpenGames extends StatefulWidget {
  const OpenGames({
    super.key,
    required this.userId,
    this.gameData,
  });

  final String userId;
  final List<AvailableGamesModel>? gameData;

  @override
  State<OpenGames> createState() => _OpenGamesState();
}

class _OpenGamesState extends State<OpenGames> {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<AvailableGamesModel>>(
      future: widget.gameData != null
          ? Future.value(widget.gameData!)
          : context.read<GetAvailableGamesProvider>().getAvailableGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: MediaQuery.of(context).size.height / 2,
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF3B4FFE),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          List<AvailableGamesModel> filteredGames = snapshot.data!
              .where((game) => game.user?.id == widget.userId)
              .toList();

          if (filteredGames.isEmpty) {
            return Center(
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
                    'Your games will appear here',
                    style: TextStyle(
                      fontFamily: 'Bold',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Tap the ‘Create Game’ button \nto get started.',
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
            );
          } else {
            return ListView.builder(
              itemCount: filteredGames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: Consumer<DynamicLinksProvider>(
                      builder: (context, links, child) {
                    return GameCard(
                      onCardTap: () {
                        Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => UserGameDetailsScreen(
                                      state: filteredGames[index].state!,
                                      isRequested: filteredGames[index].state,
                                      stake: filteredGames[index].stake,
                                      idOfGame:
                                          filteredGames[index].id.toString(),
                                      potentialWin: filteredGames[index].stake!,
                                      gameTitle: filteredGames[index].title,
                                      gameId: filteredGames[index].gameId,
                                      username:
                                          filteredGames[index].user?.username,
                                      receiverId: filteredGames[index].user?.id,
                                      receiverdeviceToken: filteredGames[index]
                                          .user
                                          ?.deviceToken,
                                      receiverAvatar:
                                          filteredGames[index].user?.avatar,
                                    )));
                      },
                      state: filteredGames[index].state!,
                      image: filteredGames[index].user?.avatar ??
                          'https://api.multiavatar.com/5b1271f9320afc278a.png',
                      username: 'Host',
                      price: filteredGames[index].stake,
                      buttonText: 'Share',
                      onTap: filteredGames[index].state!
                          ? () {
                              links
                                  .createGameLink(
                                potentialWin: calculateDiscount(double.parse(
                                        filteredGames[index].stake!))
                                    .toString(),
                                stake: filteredGames[index].stake,
                                state: filteredGames[index].state,
                                gameTitle: filteredGames[index].title,
                                gameId: filteredGames[index].gameId,
                                idOfgame: filteredGames[index].id.toString(),
                                username: filteredGames[index].user?.username,
                                senderUsername: '',
                                senderId: '',
                                receiverId: filteredGames[index].user?.id,
                                receiverDeviceToken:
                                    filteredGames[index].user?.deviceToken,
                                senderDeviceToken: '',
                                senderAvatar: '',
                                receiverAvatar:
                                    filteredGames[index].user?.avatar,
                              )
                                  .then((value) {
                                Share.share(value);
                              });
                            }
                          : null,
                      cardColor: Color.fromARGB(255, 15, 22, 44),
                    );
                  }),
                );
              },
            );
          }
        }
        return Container();
      },
    );
  }
}

class History extends StatelessWidget {
  const History({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/images/cup_black.png',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'No game history yet',
            style: TextStyle(
              fontFamily: 'Bold',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'Don’t worry when there is data \navailable, it will appear here.',
            style: TextStyle(
              fontFamily: 'Regular',
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn(duration: 500.ms),
    );
  }
}





// ListView(
//       children: [
//         HistoryListItem(
//             title: 'Won',
//             gameID: '189378922073927633',
//             date: '2023/11/09  17:14:00',
//             stakeAmount: '400',
//             currency: 'assets/images/naira_coin.png',
//             stakeAmountinReturn: '+790',
//             statusColor: Colors.green),
//         HistoryListItem(
//           title: 'Lost',
//           gameID: '189378922073927633',
//           date: '2023/11/09  17:14:00',
//           stakeAmount: '200',
//           currency: 'assets/images/naira_coin.png',
//           stakeAmountinReturn: '-200',
//           statusColor: Color(0xFFFF0000),
//         ),
//         HistoryListItem(
//           title: 'Lost',
//           gameID: '189378922073927633',
//           date: '2023/11/09  17:14:00',
//           stakeAmount: '200',
//           currency: 'assets/images/naira_coin.png',
//           stakeAmountinReturn: '-200',
//           statusColor: Color(0xFFFF0000),
//         ),
//       ],
//     )