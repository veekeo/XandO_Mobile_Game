import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/components/deposit_textfield.dart';
import 'package:xando/screens/Finance_Screens/add_card_screen.dart';

class DepositScreen extends StatefulWidget {
  const DepositScreen({super.key});

  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  bool _isSelected = false;

  void _updateSelectedCard() {
    if (_isSelected == false) {
      setState(() {
        _isSelected = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(120), // Set this height
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 13.0,
              left: 13,
              top: 50,
              bottom: 20,
            ),
            child: GestureDetector(
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
                    'Deposit',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(13, 0, 13, 0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Deposit Currency',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: const Color(0xB3FFFFFF),
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                        Text(
                          'Amount',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: 'Plus Jakarta Sans',
                                color: const Color(0xB3FFFFFF),
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                      ],
                    ),
                  ),
                  const DepositTextfield(),
                  SavedCard(
                    onTap: () {
                      _updateSelectedCard();
                    },
                    cardType: 'assets/images/visa_card.png',
                    cardNumTruncated: '****3456',
                    isSelected: _isSelected,
                  ),
                  const UseNewCard(),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: FFButtonWidget(
                      onPressed: () {},
                      text: 'Top up now',
                      options: FFButtonOptions(
                        width: 200,
                        height: 45,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                        iconPadding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        color: FlutterFlowTheme.of(context).primary,
                        textStyle:
                            FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .headlineSmallFamily),
                                ),
                        elevation: 0,
                        borderSide: const BorderSide(
                          color: Colors.transparent,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const DepositInstruction(),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SavedCard extends StatelessWidget {
  const SavedCard({
    super.key,
    required this.cardType,
    required this.cardNumTruncated,
    required this.isSelected,
    required this.onTap,
  });

  final String cardType;
  final String cardNumTruncated;
  final bool isSelected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: isSelected
          ? Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Container(
                width: double.infinity,
                height: 45,
                decoration: BoxDecoration(
                  color: const Color(0x2F00DA5F),
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: const Color(0xF800DA5F),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 5, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                cardType,
                                width: 43,
                                height: 31,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            cardNumTruncated,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          const Padding(
                            padding:
                                EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                            child: Icon(
                              Icons.check_sharp,
                              color: Color(0xF800DA5F),
                              size: 24,
                            ),
                          ),
                          Icon(
                            Icons.cancel_outlined,
                            color: FlutterFlowTheme.of(context).primaryText,
                            size: 20,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            cardType,
                            width: 43,
                            height: 31,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Text(
                        cardNumTruncated,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Plus Jakarta Sans',
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.cancel_outlined,
                    color: FlutterFlowTheme.of(context).primaryText,
                    size: 20,
                  ),
                ],
              ),
            ),
    );
  }
}

class DepositInstruction extends StatelessWidget {
  const DepositInstruction({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '1. The Minimum deposit amount is NGN 100.00.\n2. The Maximum amount per transaction is NGN 9,999,999.00. If you want to deposit more than that, please make multiple payments.\n3. We take your security seriously. Your saved credit card information is encrypted and your CVV is not stored. You will be asked to enter your Security PIN every time you use your card.\n4. We use your payment information only to verify the transaction. We do not share your information with anyone.\n5. If you have any issues, please contact customer service. The use of multiple cards/bank accounts for multiple deposits may cause errors.\n6. There are no transaction fees, the deposit is free.',
      textAlign: TextAlign.start,
      style: FlutterFlowTheme.of(context).bodyMedium.override(
            fontFamily: 'Plus Jakarta Sans',
            color: const Color(0x82FFFFFF),
            fontSize: 14,
            useGoogleFonts: GoogleFonts.asMap()
                .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
          ),
    );
  }
}

class UseNewCard extends StatelessWidget {
  const UseNewCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) {
          return const AddCardScreen();
        }));
      },
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 25, 0, 25),
        child: Text(
          '+ Use New Card',
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Plus Jakarta Sans',
                color: Colors.white70,
                fontWeight: FontWeight.bold,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
              ),
        ),
      ),
    );
  }
}
