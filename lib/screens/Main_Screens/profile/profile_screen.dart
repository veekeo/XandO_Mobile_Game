// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/reusable_widgets/sections/profile_feature.dart';
import 'package:xando/screens/Auth_Screens/onboarding_screen.dart';
import 'package:xando/screens/Finance_Screens/wallet_screen.dart';
import 'package:xando/screens/Main_Screens/earn_screen.dart';
import 'package:xando/screens/Main_Screens/profile/edit_profile_screen.dart';
import 'package:xando/utils/routers.dart';
import 'package:xando/utils/snackbar_message.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _loadedUsername;
  late int _coin;

  bool viewBalance = false;
  final String hideBalanceText = '****';
  @override
  void initState() {
    super.initState();
    _loadedUsername = '';
    _coin = 0;
    _loadUserData();
  }

  _loadUserData() async {
    String? username = await DatabaseProvider().getUserName();
    int? coin = await DatabaseProvider().getCoin();
    setState(() {
      _loadedUsername = username;
      _coin = coin;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: true,
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.all(16),
          scrollDirection: Axis.vertical,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.chevron_left,
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: AlignmentDirectional(0.00, 0.00),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (contect) {
                        return EditProfile();
                      }));
                    },
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                      child: Stack(
                        alignment: AlignmentDirectional(0, 0),
                        children: [
                          FutureBuilder<UserModel>(
                            future: EditProfileProvider().getUserProfileData(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Text('');
                              } else if (snapshot.hasError) {
                                showErrorSnackBarMessage(
                                    message: 'Something went wrong!',
                                    context: context,
                                    status: true);
                              } else {
                                return ClipOval(
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image.network(
                                        snapshot.data?.avatar ??
                                            'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                        width: 300,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                );
                              }
                              return Text('');
                            },
                          ),
                          Align(
                            alignment: AlignmentDirectional(0.292, -0.625),
                            child: Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).primary,
                                  shape: BoxShape.circle,
                                ),
                                alignment: AlignmentDirectional(0.00, 0.00),
                                child: Icon(
                                  Icons.edit_outlined,
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                FutureBuilder<UserModel>(
                  future: EditProfileProvider().getUserProfileData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return UserNameTextWidget(
                          loadedUsername: _loadedUsername);
                    } else if (snapshot.hasError) {
                      showErrorSnackBarMessage(
                          message: 'Something went wrong!',
                          context: context,
                          status: true);
                    } else {
                      return UserNameTextWidget(
                          loadedUsername:
                              snapshot.data?.username ?? _loadedUsername);
                    }
                    return UserNameTextWidget(
                        loadedUsername:
                            snapshot.data?.username ?? _loadedUsername);
                  },
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Text(
                    'Total Balance',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xB7FFFFFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            'assets/images/naira_coin.png',
                            width: 20,
                            height: 20,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      FutureBuilder<UserModel>(
                          future: EditProfileProvider().getUserProfileData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return UserCoinBalanceTextWidget(coin: _coin);
                            } else if (snapshot.hasError) {
                              showErrorSnackBarMessage(
                                  message: 'Something went wrong!',
                                  context: context,
                                  status: true);
                            } else if (snapshot.hasData) {
                              if (snapshot.data != null &&
                                  snapshot.data!.gamedata != null) {
                                if (viewBalance) {
                                  return UserCoinBalanceTextWidget(
                                    coin: snapshot.data!.gamedata!.coin,
                                  );
                                } else {
                                  return Text(
                                    hideBalanceText,
                                    style: TextStyle(
                                      fontFamily: 'Bold',
                                      fontSize: 18,
                                    ),
                                  );
                                }
                              } else {
                                return UserCoinBalanceTextWidget(coin: _coin);
                              }
                            }
                            return UserCoinBalanceTextWidget(coin: _coin);
                          }),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            viewBalance = !viewBalance;
                          });
                        },
                        child: Icon(
                          viewBalance
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined,
                          color: Color(0xB5FFFFFF),
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: FFButtonWidget(
                    onPressed: () {
                      Navigator.push(context,
                          CupertinoPageRoute(builder: (contect) {
                        return WalletScreen(selectedTabFromExternalRoute: 0);
                      }));
                    },
                    text: 'Deposit',
                    icon: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 24,
                    ),
                    options: FFButtonOptions(
                      width: 200,
                      height: 50,
                      padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                      iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                      color: FlutterFlowTheme.of(context).primary,
                      textStyle:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .headlineSmallFamily),
                              ),
                      elevation: 0,
                      borderSide: BorderSide(
                        color: Colors.transparent,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                FFButtonWidget(
                  onPressed: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (contect) {
                      return WalletScreen(selectedTabFromExternalRoute: 1);
                    }));
                  },
                  text: 'Withdraw',
                  icon: Icon(
                    Icons.monetization_on_outlined,
                    size: 24,
                  ),
                  options: FFButtonOptions(
                    width: 200,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xFF00AD1F),
                    textStyle: FlutterFlowTheme.of(context)
                        .headlineSmall
                        .override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).headlineSmallFamily),
                        ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                SizedBox(height: 10),
                // divider(),
                // ProfileFeature(
                //   onTap: () {
                //     Navigator.push(context,
                //         CupertinoPageRoute(builder: (contect) {
                //       return TransactionsScreen();
                //     }));
                //   },
                //   icon: Icons.monetization_on_outlined,
                //   feature: 'Transactions',
                //   rightSide: Icon(
                //     Icons.chevron_right,
                //     color: Color(0xB2FFFFFF),
                //     size: 24,
                //   ),
                // ),
                // divider(),
                ProfileFeature(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (contect) {
                      return EarnScreen(
                        isFromExternalSource: true,
                      );
                    }));
                  },
                  icon: Icons.auto_graph,
                  feature: 'Refer & Earn',
                  rightSide: Icon(
                    Icons.chevron_right,
                    color: Color(0xB2FFFFFF),
                    size: 24,
                  ),
                ),
                divider(),
                ProfileFeature(
                  onTap: () {
                    launchWhatsApp();
                  },
                  icon: Icons.wechat_outlined,
                  feature: 'Live Support',
                  rightSide: Icon(
                    Icons.chevron_right,
                    color: Color(0xB2FFFFFF),
                    size: 24,
                  ),
                ),
                divider(),
                SizedBox(height: 30),
                FFButtonWidget(
                  onPressed: () async {
                    final dbProvider = context.read<DatabaseProvider>();
                    await dbProvider.clearDatabase(context).then((value) =>
                        PageNavigator(ctx: context)
                            .nextPageOnly(page: const OnboardingScreen()));
                  },
                  text: 'Logout',
                  icon: Icon(
                    Icons.logout_rounded,
                    size: 24,
                  ),
                  options: FFButtonOptions(
                    width: 200,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: Color(0xff404040),
                    textStyle: FlutterFlowTheme.of(context)
                        .headlineSmall
                        .override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).headlineSmallFamily),
                        ),
                    elevation: 0,
                    borderSide: BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void launchWhatsApp() async {
    const phoneNumber =
        '+2347052075318'; // Replace with the actual WhatsApp number
    const url = 'https://wa.me/$phoneNumber';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch ${Uri.parse(url)}';
    }
  }

  Container divider() {
    return Container(
      width: double.infinity,
      height: 2,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 35, 37, 60),
      ),
    );
  }
}

class UserCoinBalanceTextWidget extends StatelessWidget {
  const UserCoinBalanceTextWidget({
    super.key,
    required this.coin,
  });

  final int coin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
      child: Text(
        coin.toString(),
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              useGoogleFonts: GoogleFonts.asMap()
                  .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
            ),
      ),
    );
  }
}

class UserNameTextWidget extends StatelessWidget {
  const UserNameTextWidget({
    super.key,
    required this.loadedUsername,
  });

  final String loadedUsername;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
      child: Text(
        loadedUsername,
        style: FlutterFlowTheme.of(context).bodyMedium.override(
              fontFamily: 'Plus Jakarta Sans',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              useGoogleFonts: GoogleFonts.asMap()
                  .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
            ),
      ),
    );
  }
}
