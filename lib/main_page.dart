import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/affliate_provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/XandO/create_a_game.dart';
import 'package:xando/models/affilaite_user_model.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/screens/Main_Screens/chat_screen.dart';
import 'package:xando/screens/Main_Screens/game_screen.dart';
import 'package:xando/screens/Main_Screens/home_screen.dart';
import 'package:xando/screens/Main_Screens/earn_screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late String _userId;
  int currentIndex = 0;

  List<Widget> screens = [
    const HomeScreen(),
    const ChatScreen(),
    const GameScreen(selectedTabFromExternalRoute: 0),
    const EarnScreen(
      isFromExternalSource: false,
    ),
  ];

  final scaffoldKey = GlobalKey<ScaffoldState>();

  //Fetching Data for GameScreen and EarnScreen

  Future<List<AvailableGamesModel>> fetchGameScreenData() async {
    final getGames = context.read<GetAvailableGamesProvider>();
    List<AvailableGamesModel> fetchedData = await getGames.getAvailableGames();
    return fetchedData;
  }

  Future<AffliateUserModel> fetchEarnScreenData() async {
    final getAffiliateUser = context.read<AffliateProvider>();
    AffliateUserModel fetchedData = await getAffiliateUser.getAffliateUser();
    return fetchedData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: _buildCustomBottomNavigationBar(),
    );
  }

  Widget _buildCustomBottomNavigationBar() {
    return BottomAppBar(
      padding: const EdgeInsets.all(0),
      color: const Color.fromARGB(255, 0, 7, 38),
      height: 70,
      child: Stack(
        children: [
          Align(
            alignment: const AlignmentDirectional(0.00, 1.00),
            child: Padding(
              padding: const EdgeInsets.all(0).copyWith(bottom: 5),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: currentIndex == 0 ? 1.0 : 0.5,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        _onTabTapped(0);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlutterFlowIconButton(
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 40,
                            icon: Icon(
                              currentIndex == 0
                                  ? Icons.home_rounded
                                  : Icons.home_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                          ),
                          Text(
                            'Home',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: currentIndex == 1 ? 1.0 : 0.5,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _onTabTapped(1);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 40,
                            icon: Icon(
                              Icons.wechat_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                          ),
                          Text(
                            'Chat',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  Opacity(
                    opacity: currentIndex == 2 ? 1.0 : 0.5,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _onTabTapped(2);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 40,
                            icon: Icon(
                              currentIndex == 2
                                  ? Icons.videogame_asset_rounded
                                  : Icons.videogame_asset_outlined,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                          ),
                          Text(
                            'Games',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: currentIndex == 3 ? 1.0 : 0.5,
                    child: InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        _onTabTapped(3);
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          FlutterFlowIconButton(
                            borderColor: Colors.transparent,
                            borderRadius: 30,
                            borderWidth: 1,
                            buttonSize: 40,
                            icon: Icon(
                              Icons.insights_rounded,
                              color: FlutterFlowTheme.of(context).primaryText,
                              size: 24,
                            ),
                          ),
                          Text(
                            'Earn',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]
                    .divide(const SizedBox(width: 24))
                    .addToStart(const SizedBox(width: 24))
                    .addToEnd(const SizedBox(width: 24)),
              ),
            ),
          ),
          Align(
            alignment: const AlignmentDirectional(0.00, 1.00),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
              child: ClipOval(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary,
                        const Color(0xFF0013BC)
                      ],
                      stops: const [0, 1],
                      begin: const AlignmentDirectional(0, -1),
                      end: const AlignmentDirectional(0, 1),
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: FlutterFlowIconButton(
                    borderRadius: 20,
                    borderWidth: 0,
                    buttonSize: 10,
                    hoverColor: FlutterFlowTheme.of(context).secondary,
                    icon: Icon(
                      Icons.add,
                      color: FlutterFlowTheme.of(context).primaryText,
                      size: 30,
                    ),
                    onPressed: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (context) {
                        return const CreateGameScreen();
                      }));
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onTabTapped(int index) async {
    setState(() {
      currentIndex = index;

      // Call the appropriate Future function based on the tapped tab
      switch (index) {
        case 2: // GameScreen
          fetchGameScreenData().then((gameData) {
            screens = List.from(screens);
            screens[2] = GameScreen(
              selectedTabFromExternalRoute: 0,
              gameData: gameData,
            );
          });
          break;
        case 3: // EarnScreen
          fetchEarnScreenData().then((earnData) {
            screens = List.from(screens);
            screens[3] = EarnScreen(
              isFromExternalSource: false,
              earnData: earnData,
            );
          });
          break;
      }
    });
  }
}
