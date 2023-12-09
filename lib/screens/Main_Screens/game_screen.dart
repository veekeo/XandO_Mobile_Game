// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/components/currency_balance_container.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/components/history_list_item.dart';
import 'package:xando/components/tabs.dart';

import 'package:xando/models/game_screen_model.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late GameScreenModel _model;
  int _selectedIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameScreenModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
                      CurrencyBalanceContainer(
                        coin: '2344',
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
                          tabTitle: 'Open(1)',
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
        child: _selectedIndex == 0 ? OpenGames() : History(),
      ),
    );
  }
}

class OpenGames extends StatelessWidget {
  const OpenGames({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13),
          child: GameCard(
            image: 'assets/images/scott_brown.png',
            username: 'Host',
            price: '4000.000',
            buttonText: 'Share',
            onTap: () {},
            cardColor: Color.fromARGB(255, 15, 22, 44),
          ),
        ),
      ],
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
