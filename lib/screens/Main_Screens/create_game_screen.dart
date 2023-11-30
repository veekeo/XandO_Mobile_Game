// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:xando/components/numeric_keyboard.dart';

Future showCreateGameBottomSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Color.fromARGB(255, 21, 28, 52),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    builder: (BuildContext context) {
      return _SheetContent();
    },
  );
}

class _SheetContent extends StatefulWidget {
  const _SheetContent();

  @override
  State<_SheetContent> createState() => _SheetContentState();
}

class _SheetContentState extends State<_SheetContent> {
  NumericKeyboard numericKeyboard = NumericKeyboard(input: '100');

  String stake = '100';

  void updateStake(String newStake) {
    setState(() {
      stake == numericKeyboard.input;
    });
  }

  bool _numericKeyboardVisibility = false;

  void toggleNumericKeyboard() {
    setState(() {
      _numericKeyboardVisibility = !_numericKeyboardVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: _numericKeyboardVisibility
            ? 320.0 + 60
            : 280, // Set the maximum height of the bottom sheet
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
                    'Host a Game',
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
              Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
                  child: Text(
                    'Amount',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xB2FFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  toggleNumericKeyboard();
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                  child: Container(
                    width: double.infinity / 2,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.asset(
                                  'assets/images/naira_coin.png',
                                  width: 22,
                                  height: 22,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                                child: Text(
                                  numericKeyboard.input,
                                  textAlign: TextAlign.start,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Icon(
                            Icons.clear_outlined,
                            color: Colors.white,
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              _numericKeyboardVisibility
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: NumericKeyboard(
                        input: numericKeyboard.input,
                      ),
                    )
                  : SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
                  child: Text(
                    'Potential Win',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Color(0xB2FFFFFF),
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
                child: Container(
                  width: double.infinity,
                  height: 45,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 32, 40, 73),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Opacity(
                              opacity: 0.7,
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
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                              child: Text(
                                '160',
                                textAlign: TextAlign.start,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: Color(0xBAFFFFFF),
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // Padding(
              //   padding: const EdgeInsets.only(left: 15, right: 15, bottom: 5),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.max,
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     crossAxisAlignment: CrossAxisAlignment.end,
              //     children: [
              //       Column(
              //         mainAxisSize: MainAxisSize.max,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Align(
              //             alignment: AlignmentDirectional(-1.00, 0.00),
              //             child: Padding(
              //               padding:
              //                   EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
              //               child: Text(
              //                 'Score Limit',
              //                 style: FlutterFlowTheme.of(context)
              //                     .bodyMedium
              //                     .override(
              //                       fontFamily: 'Plus Jakarta Sans',
              //                       color: Color(0xB2FFFFFF),
              //                       fontSize: 12,
              //                       fontWeight: FontWeight.normal,
              //                       useGoogleFonts: GoogleFonts.asMap()
              //                           .containsKey(
              //                               FlutterFlowTheme.of(context)
              //                                   .bodyMediumFamily),
              //                     ),
              //               ),
              //             ),
              //           ),
              //           Row(
              //             mainAxisSize: MainAxisSize.max,
              //             children: [
              //               Container(
              //                 width: 45,
              //                 height: 45,
              //                 decoration: BoxDecoration(
              //                   color: FlutterFlowTheme.of(context)
              //                       .primary
              //                       .withOpacity(0.5),
              //                   borderRadius: BorderRadius.circular(5),
              //                 ),
              //                 child: Icon(
              //                   Icons.arrow_drop_down_sharp,
              //                   color: FlutterFlowTheme.of(context)
              //                       .primaryBtnText
              //                       .withOpacity(0.5),
              //                   size: 28,
              //                 ),
              //               ),
              //               SizedBox(width: 8),
              //               Container(
              //                 width: 100,
              //                 height: 45,
              //                 decoration: BoxDecoration(
              //                   color: Colors.black,
              //                   borderRadius: BorderRadius.circular(5),
              //                   border: Border.all(
              //                     color: FlutterFlowTheme.of(context).primary,
              //                     width: 1,
              //                   ),
              //                 ),
              //                 child: Center(
              //                   child: Text(
              //                     '3',
              //                     style: FlutterFlowTheme.of(context)
              //                         .bodyMedium
              //                         .override(
              //                           fontFamily: 'Plus Jakarta Sans',
              //                           fontWeight: FontWeight.bold,
              //                           useGoogleFonts: GoogleFonts.asMap()
              //                               .containsKey(
              //                                   FlutterFlowTheme.of(context)
              //                                       .bodyMediumFamily),
              //                         ),
              //                   ),
              //                 ),
              //               ),
              //               SizedBox(width: 8),
              //               Container(
              //                 width: 45,
              //                 height: 45,
              //                 decoration: BoxDecoration(
              //                   color: FlutterFlowTheme.of(context).primary,
              //                   borderRadius: BorderRadius.circular(5),
              //                 ),
              //                 child: Icon(
              //                   Icons.arrow_drop_up,
              //                   color:
              //                       FlutterFlowTheme.of(context).primaryBtnText,
              //                   size: 28,
              //                 ),
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //       Column(
              //         mainAxisSize: MainAxisSize.max,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Align(
              //             alignment: AlignmentDirectional(-1.00, 0.00),
              //             child: Padding(
              //               padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
              //               child: Text(
              //                 'Audio Chat',
              //                 style: FlutterFlowTheme.of(context)
              //                     .bodyMedium
              //                     .override(
              //                       fontFamily: 'Plus Jakarta Sans',
              //                       color: Color(0xB2FFFFFF),
              //                       fontSize: 12,
              //                       fontWeight: FontWeight.normal,
              //                       useGoogleFonts: GoogleFonts.asMap()
              //                           .containsKey(
              //                               FlutterFlowTheme.of(context)
              //                                   .bodyMediumFamily),
              //                     ),
              //               ),
              //             ),
              //           ),
              //           Row(
              //             mainAxisSize: MainAxisSize.max,
              //             children: [
              //               Switch.adaptive(
              //                 value: true,
              //                 onChanged: (newValue) async {
              //                   // setState(() => _model.switchValue = newValue!);
              //                 },
              //                 activeColor: FlutterFlowTheme.of(context).primary,
              //                 activeTrackColor:
              //                     FlutterFlowTheme.of(context).accent1,
              //                 inactiveTrackColor:
              //                     FlutterFlowTheme.of(context).alternate,
              //                 inactiveThumbColor:
              //                     FlutterFlowTheme.of(context).secondaryText,
              //               ),
              //             ],
              //           ),
              //         ],
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15, 5, 15, 10),
                child: FFButtonWidget(
                  onPressed: () {},
                  text: 'Create Game',
                  options: FFButtonOptions(
                    width: double.infinity,
                    height: 50,
                    padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                    iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: FlutterFlowTheme.of(context).primary,
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
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
