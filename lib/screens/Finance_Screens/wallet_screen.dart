import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/components/tabs.dart';
import 'package:xando/screens/Finance_Screens/deposit_screen.dart';
import 'package:xando/screens/Finance_Screens/transactions_screen.dart';
import 'package:xando/screens/Finance_Screens/withdraw.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key, required this.selectedTabFromExternalRoute});
  final int selectedTabFromExternalRoute;

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _selectedIndex = 0;

  late int _coin;

  _loadUserData() async {
    int? coin = await DatabaseProvider().getCoin();
    setState(() {
      _coin = coin;
    });
  }

  void _updateIfFromExternalRoute() {
    setState(() {
      _selectedIndex = widget.selectedTabFromExternalRoute;
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _updateIfFromExternalRoute();
    _coin = 0;
    _loadUserData();
  }

  @override
  void dispose() {
    super.dispose();
    widget.selectedTabFromExternalRoute;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140), // Set this height
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
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.chevron_left,
                              size: 30,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Wallet',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              CupertinoPageRoute(builder: (context) {
                            return const TransactionsScreen();
                          }));
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.currency_exchange_outlined,
                              size: 18,
                              color: Colors.grey,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              'Transactions',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: Colors.grey,
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyMediumFamily),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
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
                          tabTitle: 'Deposit',
                        ),
                        SecondTab(
                          selectedTab: () {
                            _onTabSelected(1);
                          },
                          isSelected: _selectedIndex == 1,
                          tabTitle: 'Withdraw',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  height: 2,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 35, 37, 60),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: _selectedIndex == 0 ? Deposit(coin: _coin) : const Withdraw(),
      ),
    );
  }
}
