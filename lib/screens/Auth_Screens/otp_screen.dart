import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/phone_auth_provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/main_page.dart';
import 'package:xando/models/add_phonenumber_model.dart';
import 'package:xando/screens/Auth_Screens/add_phone_number_screen.dart';
import 'package:xando/utils/routers.dart';
import 'package:xando/utils/snackbar_message.dart';

class OTPScreen extends StatefulWidget {
  final String phoneNumber;
  const OTPScreen({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  String? otpCode;
  late String _deviceToken;

  Timer? _timer;
  int _countDown = 30;
  bool _isCountdownDone = false;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_countDown > 0) {
          _countDown--;
        } else {
          _timer?.cancel();
          _isCountdownDone = true;
        }
      });
    });
  }

  _loadUserData() async {
    String? deviceToken = await DatabaseProvider().getDeviceToken();
    if (mounted) {
      setState(() {
        _deviceToken = deviceToken;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    startTimer();
    _deviceToken = '';
    _loadUserData();
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<PhoneNumberAuthProvider>(context, listen: true).isLoading;

    return Scaffold(
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B4FFE)),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Text(
                      'Verification\n Code',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyLargeFamily),
                          ),
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(20, 0, 5, 0),
                      child: Text(
                        'Enter OTP sent to: ${widget.phoneNumber}',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).bodySmallFamily),
                            ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(5, 0, 20, 0),
                      child: Text(
                        '',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Plus Jakarta Sans',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context).bodySmallFamily),
                            ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(13, 20, 13, 0),
                  child: PinCodeTextField(
                    autoDisposeControllers: false,
                    appContext: context,
                    length: 6,
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: FlutterFlowTheme.of(context).primary,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    enableActiveFill: false,
                    autoFocus: true,
                    enablePinAutofill: true,
                    errorTextSpace: 0,
                    showCursor: true,
                    cursorColor: FlutterFlowTheme.of(context).primary,
                    obscureText: true,
                    obscuringCharacter: '●',
                    hintCharacter: '-',
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      fieldHeight: 60,
                      fieldWidth: 50,
                      borderWidth: 2,
                      borderRadius: BorderRadius.circular(12),
                      shape: PinCodeFieldShape.underline,
                      activeColor: FlutterFlowTheme.of(context).primary,
                      inactiveColor: const Color(0xFF3B4FFE),
                      selectedColor: FlutterFlowTheme.of(context).secondaryText,
                      activeFillColor: FlutterFlowTheme.of(context).primary,
                      inactiveFillColor: const Color(0xFF3B4FFE),
                      selectedFillColor:
                          FlutterFlowTheme.of(context).secondaryText,
                    ),
                    controller: otpController,
                    onChanged: (value) {
                      setState(() {
                        otpCode = value;
                      });
                    },
                    onSubmitted: (value) {},
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    // validator:
                    //     _model.pinCodeControllerValidator.asValidator(context),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(20, 0, 5, 5),
                        child: Text(
                          'Didn\'t Recieve the OTP?',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodySmall
                              .override(
                                fontFamily: 'Plus Jakarta Sans',
                                fontSize: 12,
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodySmallFamily),
                              ),
                        ),
                      ),
                      GestureDetector(
                        onTap: isLoading
                            ? null
                            : () {
                                if (_isCountdownDone) {
                                  Navigator.pushReplacement(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return const AddPhoneNumberScreen();
                                  }));
                                }
                              },
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 0, 20, 5),
                          child: Text(
                            _isCountdownDone
                                ? 'RESEND CODE'
                                : ' 00:${_countDown.toString()}',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: isLoading
                                      ? Colors.grey.withOpacity(0.5)
                                      : const Color(0xFF3B4FFE),
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodySmallFamily),
                                ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: PrimaryButton(
                      backgroundColor: const Color(0xFF3B4FFE),
                      title: 'Verify',
                      width: 200,
                      height: 55,
                      onpressed: () {
                        if (otpCode != null) {
                          verifyOtp(context, otpCode);
                        } else {
                          showErrorSnackBarMessage(
                              message: 'Enter 6-Digit Code',
                              context: context,
                              status: true);
                        }
                      },
                      isLoading: isLoading,
                    )),
              ],
            ),
    );
  }

  void verifyOtp(BuildContext context, userOtp) async {
    final ap = Provider.of<PhoneNumberAuthProvider>(context, listen: false);
    final dbProvider = context.read<DatabaseProvider>();
    final userId = await dbProvider.getUserId();

    // ignore: use_build_context_synchronously
    await ap.verifyOtp(context, userOtp).then((value) {
      if (ap.hasError == true) {
        showErrorSnackBarMessage(
            message: ap.errorCode, context: context, status: true);
      } else if (ap.isVerified) {
        ap.saveUserPhoneNumber(context, userId, {
          'contact': widget.phoneNumber,
          'devicetoken': _deviceToken,
        }).then((value) async {
          await ap.rememberUserOtp(context, true).then((value) =>
              PageNavigator(ctx: context).nextPageOnly(page: const MainPage()));
        });
      } else {
        showErrorSnackBarMessage(
            message: 'OTP Verification failed', context: context, status: true);
      }
    });

    // ignore: use_build_context_synchronously
    // ap.verifyOtp(
    //     context: context,
    //     userOtp: userOtp,
    //     onSuccess: () async {
    //       //check DB
    //       ap.saveUserPhoneNumber(context, userId, {
    //         'contact': widget.phoneNumber,
    //         'devicetoken': _deviceToken,
    //       }).then((value) {
    //         if (ap.hasError == true) {
    //           showErrorSnackBarMessage(
    //               message: ap.errorCode, context: context, status: true);
    //         } else {
    //           PageNavigator(ctx: context).nextPageOnly(page: const MainPage());
    //         }
    //       });
    //       // ignore: use_build_context_synchronously
    //     });
  }
}
