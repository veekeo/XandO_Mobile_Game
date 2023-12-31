import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/phone_auth_provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/main_page.dart';
import 'package:xando/utils/routers.dart';
import 'package:xando/utils/snackbar_message.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  final String phoneNumber;
  const OTPScreen(
      {Key? key, required this.verificationId, required this.phoneNumber})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  TextEditingController otpController = TextEditingController();
  String? otpCode;
  late String _deviceToken;

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
    _deviceToken = '';
    _loadUserData();
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
                                Navigator.pop(context);
                              },
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(5, 0, 20, 5),
                          child: Text(
                            'RESEND CODE',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodySmall
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: isLoading
                                      ? Colors.grey.withOpacity(0.5)
                                      : FlutterFlowTheme.of(context).primary,
                                  fontSize: 12,
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

    print('id is: ${dbProvider.userId}');

    ap.verifyOtp(
        context: context,
        verificationId: widget.verificationId,
        userOtp: userOtp,
        onSuccess: () async {
          //check DB
          ap.saveUserPhoneNumber(context, dbProvider.userId, {
            'contact': widget.phoneNumber,
            'devicetoken': _deviceToken,
          }).then((value) {
            if (ap.hasError == true) {
              print(dbProvider.userId);
              showErrorSnackBarMessage(
                  message: ap.errorCode, context: context, status: true);
            } else {
              PageNavigator(ctx: context).nextPageOnly(page: MainPage());
            }
          });
          // ignore: use_build_context_synchronously
        });
  }
}
