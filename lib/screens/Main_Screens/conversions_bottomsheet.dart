// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/reusable_widgets/conversion_row.dart';

Future showConversionsBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Color.fromARGB(255, 21, 28, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (BuildContext context) {
      return SheetContent();
    },
  );
}

class SheetContent extends StatefulWidget {
  const SheetContent({
    super.key,
  });

  @override
  State<SheetContent> createState() => _SheetContentState();
}

class _SheetContentState extends State<SheetContent> {
  bool _isDollarSelected = false;
  bool _isNairaSelected = true;

  void _selectDollarRate() {
    if (_isDollarSelected == false) {
      setState(() {
        _isDollarSelected = !_isDollarSelected;
        _isNairaSelected = !_isNairaSelected;
      });
    }
  }

  void _selectNairaRate() {
    if (_isNairaSelected == false) {
      setState(() {
        _isNairaSelected = !_isNairaSelected;
        _isDollarSelected = !_isDollarSelected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 270.0, // Set the maximum height of the bottom sheet
      ),
      width: double.infinity,
      // Add your bottom sheet content here
      padding: EdgeInsets.all(0),
      child: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Align(
              alignment: AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                child: Text(
                  'Wallet Settings',
                  textAlign: TextAlign.center,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xB2FFFFFF),
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 32, 40, 73),
                ),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(23, 0, 23, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Coins',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Plus Jakarta Sans',
                              color: Color(0xB2FFFFFF),
                              fontWeight: FontWeight.normal,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                'assets/images/naira_coin.png',
                                width: 22,
                                height: 22,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Text(
                            '0.00',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.00, 0.00),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(23, 0, 0, 15),
                child: Text(
                  'Conversions',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: Color(0xB2FFFFFF),
                        fontWeight: FontWeight.normal,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                _selectDollarRate();
                Navigator.pop(context);
              },
              child: _isDollarSelected
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      child: ConversionRow(
                        icon: 'assets/images/dollar_coin.png',
                        currency: 'USD',
                        rate: '0.00',
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: ConversionRow(
                        icon: 'assets/images/dollar_coin.png',
                        currency: 'USD',
                        rate: '0.00',
                      ),
                    ),
            ),
            GestureDetector(
              onTap: () {
                _selectNairaRate();
                Navigator.pop(context);
              },
              child: _isNairaSelected
                  ? Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).primary,
                        ),
                      ),
                      child: ConversionRow(
                        icon: 'assets/images/naira_coin.png',
                        currency: 'NGN',
                        rate: '0.00',
                      ),
                    )
                  : Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      width: double.infinity,
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.transparent,
                        ),
                      ),
                      child: ConversionRow(
                        icon: 'assets/images/naira_coin.png',
                        currency: 'NGN',
                        rate: '0.00',
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
