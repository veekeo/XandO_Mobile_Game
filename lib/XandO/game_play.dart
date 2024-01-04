import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rive/rive.dart';
import 'package:xando/Providers/Game/audio_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/XandO/components/game_stream.dart';
import 'package:xando/models/user_profile_model.dart';

class XandOGameScreen extends StatefulWidget {
  const XandOGameScreen({
    super.key,
    required this.gameId,
    required this.stake,
  });

  final String gameId;
  final double stake;

  @override
  State<XandOGameScreen> createState() => _XandOGameScreenState();
}

class _XandOGameScreenState extends State<XandOGameScreen> {
  late UserModel userData;
  late Future _userDataFuture;
  Future<UserModel> fetchUserData() async {
    userData = await EditProfileProvider().getUserProfileData();
    return userData;
  }

  @override
  void initState() {
    userData = UserModel();
    _userDataFuture = fetchUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isSoundOn =
        Provider.of<AudioProvider>(context, listen: true).isSoundOn;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Consumer<AudioProvider>(builder: (context, audio, child) {
                    return Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: const Color(0xFF3B4FFE),
                          borderRadius: BorderRadius.circular(10)),
                      child: IconButton(
                        onPressed: () {
                          audio.toggleSound();
                          print('clicked');
                        },
                        icon: isSoundOn
                            ? const Icon(
                                Icons.volume_up,
                              )
                            : const Icon(
                                Icons.volume_off,
                              ),
                      ),
                    );
                  }),
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: Color(0xFFF2BD02),
                        size: 18,
                      ),
                      FutureBuilder<UserModel>(
                          future: fetchUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text(
                                '0',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return Text(
                                userData.gamedata!.coin.toString(),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              );
                            }
                          }),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: FutureBuilder<void>(
            future: _userDataFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return GameStreamBuilderWidget(
                  gameId: widget.gameId,
                  userId: userData.id!,
                  stake: widget.stake,
                  coin: userData.gamedata!.coin,
                );
              } else {
                return const NoConnectionWidget(message: 'Loading...');
              }
            }),
      ),
    );
  }
}

class NoConnectionWidget extends StatelessWidget {
  const NoConnectionWidget({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 100,
              width: 100,
              child: RiveAnimation.asset(
                'assets/images/loader.riv',
                fit: BoxFit.cover,
              ),
            ),
            Text(
              message,
              style: const TextStyle(
                fontFamily: 'Bold',
                fontSize: 20,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
