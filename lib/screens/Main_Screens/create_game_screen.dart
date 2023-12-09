// ignore_for_file: prefer_const_constructors

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gameTitleController = TextEditingController();
  NumericKeyboard numericKeyboard = NumericKeyboard(input: '100');

  String stake = '100';

  void updateStake(String newStake) {
    setState(() {
      stake == numericKeyboard.input;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxHeight: 450
          // Set the maximum height of the bottom sheet
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
              SizedBox(height: 10),
              Align(
                alignment: AlignmentDirectional(-1.00, 0.00),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 0, 15, 5),
                  child: Text(
                    'Game Title',
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
                child: Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: _gameTitleController,
                    onChanged: (value) => EasyDebounce.debounce(
                      '_gameTitleController',
                      const Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    textCapitalization: TextCapitalization.none,
                    decoration: customInputDecoration(
                      context: context,
                      hintText: 'Enter a Game Title',
                    ),
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          fontFamily: 'Plus Jakarta Sans',
                          fontSize: 16,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).bodyMediumFamily),
                        ),
                    textAlign: TextAlign.start,
                    maxLength: 15,
                    maxLengthEnforcement: MaxLengthEnforcement.enforced,
                    buildCounter: (context,
                            {required currentLength,
                            required isFocused,
                            maxLength}) =>
                        null,
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    maxLines: 1,
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Failed!';
                      }

                      return null;
                    },
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
              Padding(
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
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: NumericKeyboard(
                  input: numericKeyboard.input,
                ),
              ),
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

  InputDecoration customInputDecoration({
    required BuildContext context,
    required String hintText,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
            fontFamily: 'Plus Jakarta Sans',
            color: const Color(0x84FFFFFF),
            useGoogleFonts: GoogleFonts.asMap()
                .containsKey(FlutterFlowTheme.of(context).labelMediumFamily),
          ),
      contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color(0x85FFFFFF),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).primary,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: FlutterFlowTheme.of(context).error,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}






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