import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/auth_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/reusable_widgets/check_password.dart';
import 'package:xando/utils/snackbar_message.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final PageController _pageController = PageController();
  // int _currentPage = 0;
  bool isScrollingEnabled = false;

  //For the OTP Page
  TextEditingController otpController = TextEditingController();
  String? otpCode;

  //For the Reset PAssword Page
  bool _isVisible = false;
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordFieldTapped = false;
  bool _isPasswordEightCharacters = false;
  bool _passwordAtleastHasOneNumber = false;
  final numericRegex = RegExp('[0-9]');
  onPasswordChanged(String password) {
    if (password.length >= 8) {
      setState(() {
        _isPasswordEightCharacters = true;
      });
    } else {
      setState(() {
        _isPasswordEightCharacters = false;
      });
    }

    if (numericRegex.hasMatch(password)) {
      setState(() {
        _passwordAtleastHasOneNumber = true;
      });
    } else {
      setState(() {
        _passwordAtleastHasOneNumber = false;
      });
    }
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
                    'Forgot Password',
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
      body: PageView(
        controller: _pageController,
        physics: isScrollingEnabled
            ? const AlwaysScrollableScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Text(
                      'Verify \nEmail Address',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyLargeFamily),
                          ),
                    ),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                    child: Text(
                      'Enter the email address \nassociated with your account',
                      textAlign: TextAlign.center,
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily: 'Plus Jakarta Sans',
                            color: const Color(0xB1FFFFFF),
                            fontSize: 14,
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyLargeFamily),
                          ),
                    ),
                  ),
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        // autofocus: true,
                        cursorColor: const Color(0xFF3B4FFE),
                        keyboardType: TextInputType.emailAddress,
                        decoration: customInputDecoration(
                          context,
                          "Enter Email Address",
                          'Email Address',
                          Icons.mail_outlined,
                          const Icon(
                            Icons.access_alarm,
                            color: Colors.transparent,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          // Use a regular expression for email validation
                          // This is a basic example; you may want to use a more comprehensive one
                          if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 15),
                      Consumer<AuthenticationProvider>(
                          builder: (context, auth, child) {
                        return PrimaryButton(
                          backgroundColor: const Color(0xFF3B4FFE),
                          title: 'Send OTP',
                          width: 200,
                          height: 55,
                          onpressed: () {
                            if (_formKey.currentState?.validate() ?? false) {
                              auth
                                  .sendEmailOTP(_emailController.text.trim())
                                  .then(
                                    (value) => _pageController.nextPage(
                                      duration:
                                          const Duration(milliseconds: 500),
                                      curve: Curves.easeInOut,
                                    ),
                                  );
                            } else {
                              showErrorSnackBarMessage(
                                message: 'Please fill in the required fields!',
                                context: context,
                                status: false,
                              );
                            }
                          },
                          isLoading: auth.isLoading,
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Consumer<AuthenticationProvider>(builder: (context, auth, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                    child: Text(
                      'Verification Code',
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
                        'Enter OTP sent to: \n${_emailController.text}',
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
                      print(value);
                      setState(() {
                        otpController.text = value;
                      });
                    },
                    onSubmitted: (value) {},
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                        onTap: auth.isLoading
                            ? null
                            : () {
                                _pageController.previousPage(
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.easeInOut,
                                );
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
                                  color: auth.isLoading
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
                      title: 'Verify OTP',
                      width: 200,
                      height: 55,
                      onpressed: () async {
                        print(otpController.text);
                        await auth.verifyEmailOTP(otpController).then((value) {
                          if (value == true) {
                            showSuccessSnackBarMessage(
                                message: auth.resMessage,
                                context: context,
                                status: true);
                            _pageController.nextPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeInOut,
                            );
                          } else {
                            showErrorSnackBarMessage(
                                message: auth.resMessage,
                                context: context,
                                status: true);
                          }
                        });
                      },
                      isLoading: false,
                    )),
              ],
            );
          }),
          Consumer<AuthenticationProvider>(builder: (context, auth, child) {
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Align(
                        alignment: const AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                          child: Text(
                            'Reset Password',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: const AlignmentDirectional(0.00, 0.00),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                          child: Text(
                            'You can now reset your password with a new password',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyLarge
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  color: const Color(0xB1FFFFFF),
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyLargeFamily),
                                ),
                          ),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              onTap: () {
                                setState(() {
                                  _isPasswordFieldTapped = true;
                                });
                              },
                              onChanged: (value) {
                                onPasswordChanged(value);
                              },
                              controller: _newPasswordController,
                              // autofocus: true,
                              obscureText: !_isVisible,
                              cursorColor: const Color(0xFF3B4FFE),
                              keyboardType: TextInputType.visiblePassword,
                              decoration: customInputDecoration(
                                context,
                                "Create new password",
                                'New password',
                                Icons.lock_outline_rounded,
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isVisible = !_isVisible;
                                    });
                                  },
                                  icon: _isVisible
                                      ? const Icon(
                                          Icons.visibility,
                                          color: Color(0xFF3B4FFE),
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value != _confirmPasswordController.text) {
                                  return 'Passwords does not match';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                if (!numericRegex.hasMatch(value)) {
                                  return 'Password must have at least one number';
                                }
                                // You can add additional password validation logic here if needed
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _confirmPasswordController,
                              onTap: () {
                                setState(() {
                                  _isPasswordFieldTapped = true;
                                });
                              },
                              obscureText: !_isVisible,
                              cursorColor: const Color(0xFF3B4FFE),
                              keyboardType: TextInputType.visiblePassword,
                              decoration: customInputDecoration(
                                context,
                                "Confirm your password",
                                'Confirm Password',
                                Icons.lock_outline_rounded,
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _isVisible = !_isVisible;
                                    });
                                  },
                                  icon: _isVisible
                                      ? const Icon(
                                          Icons.visibility,
                                          color: Color(0xFF3B4FFE),
                                        )
                                      : const Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey,
                                        ),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Passwords does not match!';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                if (!numericRegex.hasMatch(value)) {
                                  return 'Password must have at least one number';
                                }
                                // You can add additional password validation logic here if needed
                                return null;
                              },
                            ),
                            _isPasswordFieldTapped
                                ? CheckPassword(
                                    isPasswordEightCharacters:
                                        _isPasswordEightCharacters,
                                    passwordAtleastHasOneNumber:
                                        _passwordAtleastHasOneNumber,
                                  )
                                : const SizedBox(height: 10),
                            const SizedBox(height: 15),
                            PrimaryButton(
                              backgroundColor: const Color(0xFF3B4FFE),
                              title: 'Continue',
                              width: 200,
                              height: 55,
                              onpressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  auth
                                      .changePassword(
                                          context,
                                          _emailController.text.trim(),
                                          _confirmPasswordController.text
                                              .trim())
                                      .then((value) {
                                    Navigator.pop(context);
                                    showSuccessSnackBarMessage(
                                      message: 'Password changed!',
                                      context: context,
                                      status: false,
                                    );
                                  });
                                } else if (_newPasswordController.text !=
                                    _confirmPasswordController.text) {
                                  showErrorSnackBarMessage(
                                    message: 'Passwords does not match!',
                                    context: context,
                                    status: false,
                                  );
                                } else {
                                  showErrorSnackBarMessage(
                                    message:
                                        'Please fill in the required fields!',
                                    context: context,
                                    status: false,
                                  );
                                }
                              },
                              isLoading: auth.isLoading,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          })
        ],
      ),
    );
  }

  //handling google sign in

  InputDecoration customInputDecoration(
    BuildContext context,
    String hintText,
    String labelText,
    IconData prefix,
    Widget suffix,
  ) {
    return InputDecoration(
      hintText: hintText,
      labelText: labelText,
      labelStyle: FlutterFlowTheme.of(context).labelMedium,
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
      prefixIcon: Icon(
        prefix,
        color: const Color(0xFF3B4FFE),
      ),
      suffixIcon: suffix,
    );
  }
}
