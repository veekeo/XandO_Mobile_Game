// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/components/currency_balance_container.dart';

import 'package:xando/components/profile_avatar_screen.dart';
import 'package:xando/screens/Finance_Screens/wallet_screen.dart';

import 'package:xando/screens/Main_Screens/profile_screen.dart';
import 'package:xando/screens/Main_Screens/search_screen.dart';

class ReusableAppBar extends StatelessWidget {
  const ReusableAppBar({
    super.key,
  });

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
              image: 'assets/images/profile_pic.png',
              imageSize: 45,
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
                CurrencyBalanceContainer(),
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
