// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, library_private_types_in_public_api, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/get_available_games_provider.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/components/game_card.dart';
import 'package:xando/models/available_games_model.dart';
import 'package:xando/models/home_screen_model.dart';
import 'package:xando/reusable_widgets/banner_pageview.dart';
import 'package:xando/reusable_widgets/reusable_appbar.dart';
import 'package:xando/utils/snackbar_message.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StreamController<List<AvailableGamesModel>> _streamController =
      StreamController.broadcast();

  late int _coin;
  late HomePageModel _model;
  late Timer _timer;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  _loadUserData() async {
    int? coin = await DatabaseProvider().getCoin();
    if (mounted) {
      setState(() {
        _coin = coin;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _coin = 0;
    _loadUserData();
    _model = createModel(context, () => HomePageModel());

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) {
        getAvailableGames();
      } else {
        // Ensure that the timer is canceled when the widget is disposed
        timer.cancel();
      }
    });

    // _timer = Timer.periodic(Duration(seconds: 5), (timer) {
    //   if (mounted) {
    //     getAvailableGames();
    //   }
    // });

    // Timer.periodic(Duration(seconds: 5), (timer) {
    //   getAvailableGames();
    // });
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
          preferredSize: Size.fromHeight(120), // Set this height
          child: ReusableAppBar(
            coin: _coin,
          ),
        ),
        body: CustomScrollView(
          physics: BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Container(
                height: 150,
                child: Container(
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
                  final dbProvider = context.read<DatabaseProvider>();

                  List<AvailableGamesModel> filteredGames = snapshot.data!
                      .where((game) => game.user?.id != dbProvider.userId)
                      .toList();

                  if (filteredGames.isNotEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(13, 0, 13, 15),
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
                                  decoration: BoxDecoration(),
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
                                          color: Color(0xFFB1B1B1),
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  )
                                : Text(''),
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
                  final dbProvider = context.read<DatabaseProvider>();

                  List<AvailableGamesModel> filteredGames = snapshot.data!
                      .where((game) => game.user?.id != dbProvider.userId)
                      .toList();

                  //.
                  if (filteredGames.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Text('No Available Games'),
                      ),
                    );
                  } else {
                    return SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 13),
                            child: GameCard(
                              image: 'assets/images/scott_brown.png',
                              username: filteredGames[index].user?.username,
                              price: filteredGames[index].stake,
                              buttonText: 'Join',
                              onTap: () {},
                              cardColor: Color.fromARGB(255, 15, 22, 44),
                            ),
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
}
