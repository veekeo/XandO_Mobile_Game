import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/auth_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/reusable_widgets/check_password.dart';

import 'package:xando/screens/Auth_Screens/signin_screen.dart';

import 'package:xando/utils/snackbar_message.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordFieldTapped = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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

  bool _isVisible = false;

  final String _signUpSuccessful = 'Account created';
  final String _emailAlreadyExist = 'User with this email already exists';
  final String _noInternerConnection = 'Internet Connection is not available';
  final String _tryAgain = 'Please try again!';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                      child: Text(
                        'Welcome',
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
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                      child: Text(
                        'Create an X and O account',
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
                            if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          onTap: () {
                            setState(() {
                              _isPasswordFieldTapped = true;
                            });
                          },
                          onChanged: (value) {
                            onPasswordChanged(value);
                          },
                          controller: _passwordController,
                          // autofocus: true,
                          obscureText: !_isVisible,
                          cursorColor: const Color(0xFF3B4FFE),
                          keyboardType: TextInputType.visiblePassword,
                          decoration: customInputDecoration(
                            context,
                            "Enter Password",
                            'Password',
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
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Theme(
                              data: ThemeData(
                                checkboxTheme: CheckboxThemeData(
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                unselectedWidgetColor:
                                    FlutterFlowTheme.of(context).secondaryText,
                              ),
                              child: Checkbox(
                                value: true,
                                onChanged: (newValue) async {
                                  // setState(
                                  //     () => _model.checkboxValue = newValue!);
                                },
                                activeColor:
                                    FlutterFlowTheme.of(context).primary,
                                checkColor: FlutterFlowTheme.of(context).info,
                              ),
                            ),
                            Align(
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: Text(
                                'Remember me',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyLarge
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0xB1FFFFFF),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyLargeFamily),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Consumer<AuthenticationProvider>(
                          builder: (context, auth, child) {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (auth.resMessage == _signUpSuccessful) {
                                showSuccessSnackBarMessage(
                                  message: auth.resMessage,
                                  context: context,
                                  status: true,
                                );
                                auth.clear();
                              }
                              if (auth.resMessage == _emailAlreadyExist) {
                                showErrorSnackBarMessage(
                                  message: auth.resMessage,
                                  context: context,
                                  status: true,
                                );
                                auth.clear();
                              }
                              if (auth.resMessage == _noInternerConnection) {
                                showErrorSnackBarMessage(
                                  message: auth.resMessage,
                                  context: context,
                                  status: true,
                                );
                                auth.clear();
                              }
                              if (auth.resMessage == _tryAgain) {
                                showErrorSnackBarMessage(
                                  message: auth.resMessage,
                                  context: context,
                                  status: true,
                                );
                                auth.clear();
                              }
                            });
                            return PrimaryButton(
                              title: 'Sign up',
                              width: 200,
                              height: 55,
                              onpressed: () {
                                if (_formKey.currentState?.validate() ??
                                    false) {
                                  auth.registerUser(
                                    email: _emailController.text.trim(),
                                    password: _passwordController.text.trim(),
                                    context: context,
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
                            );
                          },
                        ),
                        const SizedBox(height: 15),
                        Align(
                          alignment: const AlignmentDirectional(0.00, 0.00),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: Text(
                              'Or Sign up with',
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context)
                                  .bodyLarge
                                  .override(
                                    fontFamily: 'Plus Jakarta Sans',
                                    color: const Color(0xB1FFFFFF),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                    useGoogleFonts: GoogleFonts.asMap()
                                        .containsKey(
                                            FlutterFlowTheme.of(context)
                                                .bodyLargeFamily),
                                  ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 0, 5, 0),
                              child: Container(
                                width: 97,
                                height: 55,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 32, 40, 73),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Align(
                                  alignment:
                                      const AlignmentDirectional(0.00, 0.00),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      'assets/images/Google.png',
                                      width: 37,
                                      height: 37,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 97,
                              height: 55,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 32, 40, 73),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Align(
                                alignment:
                                    const AlignmentDirectional(0.00, 0.00),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.asset(
                                    'assets/images/facebook.png',
                                    width: 32,
                                    height: 32,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: const AlignmentDirectional(0.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 5, 0),
                                child: Text(
                                  'Already have an account?',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily),
                                      ),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pushReplacement(
                                    CupertinoPageRoute(builder: (_) {
                                  return const SignInScreen();
                                }));
                              },
                              child: Align(
                                alignment:
                                    const AlignmentDirectional(0.00, 0.00),
                                child: Text(
                                  'Sign in',
                                  textAlign: TextAlign.center,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyLarge
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyLargeFamily),
                                      ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
