// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/components/currency_balance_container.dart';

import 'package:xando/components/profile_avatar_screen.dart';
import 'package:xando/screens/Finance_Screens/wallet_screen.dart';

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
        child: Wrap(
          direction: Axis.horizontal,
          alignment: WrapAlignment.center,
          runAlignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            ProfileAvatar(
              image: 'https://api.multiavatar.com/dc8d09961b64430bc4.png',
              imageSize: 40,
              onTap: () {
                Navigator.push(context, CupertinoPageRoute(builder: (contect) {
                  return ProfileScreen();
                }));
              },
            ),
            Wrap(
              alignment: WrapAlignment.center,
              runAlignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (contect) {
                      return SearchScreen();
                    }));
                  },
                  icon: Icon(Icons.search),
                ),
                Container(
                  width: 125,
                  height: 29,
                  padding: EdgeInsets.symmetric(horizontal: 3),
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
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                        child: Text(
                          widget.coin.toString(),
                          style: const TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // const Icon(
                      //   Icons.keyboard_arrow_down,
                      // ),
                    ],
                  ),
                ),
                SizedBox(width: 5),
                FFButtonWidget(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (context) {
                      return WalletScreen();
                    }));
                  },
                  text: 'Deposit',
                  options: FFButtonOptions(
                    width: 74,
                    height: 29,
                    padding: EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                SizedBox(width: 5),
                Container(
                  width: 37,
                  height: 29,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 32, 40, 73),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(
                    Icons.notifications,
                    size: 20,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
