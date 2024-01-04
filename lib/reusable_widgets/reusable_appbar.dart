import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/components/profile_avatar_screen.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/screens/Finance_Screens/wallet_screen.dart';
import 'package:xando/screens/Main_Screens/game_requests.dart';
import 'package:xando/screens/Main_Screens/notifications_screen.dart';

import 'package:xando/screens/Main_Screens/profile/profile_screen.dart';
import 'package:xando/screens/Main_Screens/search_screen.dart';

// ignore: must_be_immutable
class ReusableAppBar extends StatefulWidget {
  ReusableAppBar({
    required this.coin,
    super.key,
  });

  int coin;

  @override
  State<ReusableAppBar> createState() => _ReusableAppBarState();
}

class _ReusableAppBarState extends State<ReusableAppBar> {
  @override
  void initState() {
    super.initState();

    widget.coin = 0;
    _loadUserData();
  }

  _loadUserData() async {
    int? coin = await DatabaseProvider().getCoin();
    setState(() {
      widget.coin = coin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 50,
          bottom: 20,
        ),
        child: Column(
          children: [
            Wrap(
              direction: Axis.horizontal,
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FutureBuilder<UserModel>(
                    future: EditProfileProvider().getUserProfileData(),
                    builder: (context, snapshot) {
                      return ProfileAvatar(
                        image: snapshot.data?.avatar ??
                            'https://api.multiavatar.com/5b1271f9320afc278a.png',
                        imageSize: 40,
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (contect) {
                            return const ProfileScreen();
                          }));
                        },
                      );
                    }),
                Wrap(
                  alignment: WrapAlignment.center,
                  runAlignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (contect) {
                          return const GameRequestsScreen();
                        }));
                      },
                      icon: const Icon(Icons.people),
                    ),
                    Container(
                      width: 125,
                      height: 29,
                      padding: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 32, 40, 73),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        runAlignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              'assets/images/naira_coin.png',
                              width: 15,
                              height: 15,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  2, 0, 0, 0),
                              child: FutureBuilder<UserModel>(
                                future:
                                    EditProfileProvider().getUserProfileData(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text(
                                      snapshot.data!.gamedata?.coin == null
                                          ? '0'
                                          : '${snapshot.data!.gamedata!.coin}',
                                      style: const TextStyle(
                                        fontFamily: 'Medium',
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  } else {
                                    return const Text('0');
                                  }

                                  // Rest of the code for displaying data
                                },
                              )),
                          // const Icon(
                          //   Icons.keyboard_arrow_down,
                          // ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    FFButtonWidget(
                      onPressed: () {
                        Navigator.push(context,
                            CupertinoPageRoute(builder: (context) {
                          return const WalletScreen(
                              selectedTabFromExternalRoute: 0);
                        }));
                      },
                      text: 'Deposit',
                      options: FFButtonOptions(
                        width: 74,
                        height: 29,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).titleSmall.override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .titleSmallFamily),
                                ),
                        elevation: 0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    const SizedBox(width: 5),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const NotificationsScreen()));
                      },
                      child: Container(
                        width: 37,
                        height: 29,
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 32, 40, 73),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: const Icon(
                          Icons.notifications,
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (contect) {
                  return const SearchScreen();
                }));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 32, 40, 73),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (contect) {
                            return const SearchScreen();
                          }));
                        },
                        icon: const Icon(Icons.search),
                      ),
                      Text(
                        'Search Game by ID, Title...',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontFamily: 'Medium',
                          fontSize: 13,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
