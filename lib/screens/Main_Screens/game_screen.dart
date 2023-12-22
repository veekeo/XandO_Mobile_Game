// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/components/currency_balance_container.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/components/history_list_item.dart';
import 'package:xando/components/tabs.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/models/game_screen_model.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/utils/snackbar_message.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key, required this.selectedTabFromExternalRoute});
  final int selectedTabFromExternalRoute;

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
        preferredSize: Size.fromHeight(140), // Set this height
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
        child: _selectedIndex == 0 ? OpenGames(userId: _userId) : History(),
      ),
    );
  }
}

class OpenGames extends StatefulWidget {
  const OpenGames({
    super.key,
    required this.userId,
  });

  final String userId;

  @override
  State<OpenGames> createState() => _OpenGamesState();
}

class _OpenGamesState extends State<OpenGames> {
  final StreamController<List<AvailableGamesModel>> _streamController =
      StreamController.broadcast();
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
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
        message: 'You seem to be offline',
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<AvailableGamesModel>>(
      stream: _streamController.stream,
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
              child: Text('No Available Games'),
            );
          } else {
            return ListView.builder(
              itemCount: filteredGames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: GameCard(
                    image: 'assets/images/scott_brown.png',
                    username: 'Host',
                    price: filteredGames[index].stake,
                    buttonText: 'Share',
                    onTap: () {},
                    cardColor: Color.fromARGB(255, 15, 22, 44),
                  ),
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
    return ListView(
      children: [
        HistoryListItem(
            title: 'Won',
            gameID: '189378922073927633',
            date: '2023/11/09  17:14:00',
            stakeAmount: '400',
            currency: 'assets/images/naira_coin.png',
            stakeAmountinReturn: '+790',
            statusColor: Colors.green),
        HistoryListItem(
          title: 'Lost',
          gameID: '189378922073927633',
          date: '2023/11/09  17:14:00',
          stakeAmount: '200',
          currency: 'assets/images/naira_coin.png',
          stakeAmountinReturn: '-200',
          statusColor: Color(0xFFFF0000),
        ),
        HistoryListItem(
          title: 'Lost',
          gameID: '189378922073927633',
          date: '2023/11/09  17:14:00',
          stakeAmount: '200',
          currency: 'assets/images/naira_coin.png',
          stakeAmountinReturn: '-200',
          statusColor: Color(0xFFFF0000),
        ),
      ],
    );
  }
}
