// ignore_for_file: use_build_context_synchronously

import 'package:easy_debounce/easy_debounce.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/Providers/paystack_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/models/user_profile_model.dart';

import 'package:xando/utils/snackbar_message.dart';

class Deposit extends StatefulWidget {
  const Deposit({super.key, required this.coin});

  final int coin;

  @override
  State<Deposit> createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _stakeAmountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  _loadUserData() async {
    String email = await DatabaseProvider().getEmail();
    setState(() {
      _emailController.text = email;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(13, 0, 13, 0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                  child: FutureBuilder<UserModel>(
                    future: EditProfileProvider().getUserProfileData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.none) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF3B4FFE),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        return Container(
                          width: double.infinity,
                          height: 130,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF913BFE),
                                FlutterFlowTheme.of(context).primary
                              ],
                              stops: const [0, 1],
                              begin: const AlignmentDirectional(0, -1),
                              end: const AlignmentDirectional(0, 1),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                15, 10, 15, 10),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 8),
                                  child: Text(
                                    'Balance',
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
                                Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 5),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      //Future Builder
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 8),
                                        child: Text(
                                          '${snapshot.data?.gamedata?.coin ?? 0} NGN',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                fontFamily: 'Plus Jakarta Sans',
                                                fontSize: 32,
                                                fontWeight: FontWeight.bold,
                                                useGoogleFonts: GoogleFonts
                                                        .asMap()
                                                    .containsKey(
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMediumFamily),
                                              ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Deposit Currency',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              fontFamily: 'Plus Jakarta Sans',
                              color: const Color(0xB3FFFFFF),
                              useGoogleFonts: GoogleFonts.asMap().containsKey(
                                  FlutterFlowTheme.of(context)
                                      .bodyMediumFamily),
                            ),
                      ),
                      Text(
                        'Amount',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                //Deposit Texfied here

                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      controller: _stakeAmountController,
                      autofocus: true,
                      textCapitalization: TextCapitalization.none,
                      obscureText: false,
                      decoration: InputDecoration(
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
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 5, 0),
                              child: Text(
                                'NGN',
                                style: TextStyle(
                                  fontFamily: 'Medium',
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Container(
                              width: 2,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 82, 82, 82),
                              ),
                            ),
                          ],
                        ),
                        hintText: 'MIN. 100',
                        hintStyle: const TextStyle(
                          fontFamily: 'Medium',
                          color: Color(0x75FFFFFF),
                          fontSize: 14,
                        ),
                        errorStyle: const TextStyle(
                          fontFamily: 'Medium',
                          color: Colors.red,
                          fontSize: 14,
                        ),
                        contentPadding:
                            const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                      ),
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.end,
                      maxLength: 11,
                      maxLengthEnforcement: MaxLengthEnforcement.enforced,
                      buildCounter: (context,
                              {required currentLength,
                              required isFocused,
                              maxLength}) =>
                          null,
                      keyboardType: TextInputType.phone,
                      cursorColor: const Color(0xFF3B4FFE),
                      // validator: _model.textControllerValidator
                      // .asValidator(context),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Stake cannot be empty';
                        }
                        if (value.length < 3 || value.startsWith('0')) {
                          return 'Stake of that amount is not allowed';
                        }

                        return null;
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]'))
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                //Email Textfied here
                TextFormField(
                  autofocus: true,
                  controller: _emailController,
                  onChanged: (value) => EasyDebounce.debounce(
                    '_emailController',
                    const Duration(milliseconds: 2000),
                    () => setState(() {}),
                  ),
                  textCapitalization: TextCapitalization.none,
                  decoration: customInputDecoration(
                    context: context,
                    hintText: 'Email Address',
                  ),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                  textAlign: TextAlign.start,
                  maxLengthEnforcement: MaxLengthEnforcement.enforced,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.done,
                  maxLines: 1,
                  cursorColor: FlutterFlowTheme.of(context).primary,
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
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 20),
                  child: PrimaryButton(
                    backgroundColor: const Color(0xFF3B4FFE),
                    title: 'Top up now',
                    width: 200,
                    height: 55,
                    onpressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        handlePaystackDeposit();
                      } else {
                        showErrorSnackBarMessage(
                          message: 'Please fill in the required fields!',
                          context: context,
                          status: false,
                        );
                      }
                    },
                    isLoading:
                        Provider.of<PaystackProvider>(context, listen: true)
                            .isLoading,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // handle paystack deposit
  Future handlePaystackDeposit() async {
    final paystack = context.read<PaystackProvider>();
    UserModel initialUserBalance =
        await EditProfileProvider().getUserProfileData();

    int paymentAmount = int.parse(_stakeAmountController.text.trim()) * 100;
    //internet provider
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else {
      PayWithPayStack().now(
          context: context,
          secretKey: "sk_live_c0b3015a647d231ca553ed1d5ea2d417560e420c",
          customerEmail: _emailController.text.trim(),
          reference: DateTime.now().microsecondsSinceEpoch.toString(),
          callbackUrl: "https://google.com",
          currency: "NGN",
          amount: paymentAmount.toString(),
          transactionCompleted: () async {
            await paystack
                .calcUserTotalAmount(context, initialUserBalance.gamedata!.coin,
                    int.parse(_stakeAmountController.text.trim()))
                .then((value) => Navigator.pop(context));
          },
          transactionNotCompleted: () {
            showErrorSnackBarMessage(
              message: 'Transaction not successful.',
              context: context,
              status: false,
            );
          });
      // await paystack
      //     .getPaystackCheckoutUrl(
      //         _emailController.text.trim(), _stakeAmountController.text.trim())
      //     .then((value) {
      //   if (paystack.hasError == true) {
      //     // ignore: use_build_context_synchronously
      //     showErrorSnackBarMessage(
      //       message: paystack.resMessage,
      //       context: context,
      //       status: false,
      //     );
      //   } else {
      //     Navigator.of(context)
      //         .pushReplacement(CupertinoPageRoute(builder: (_) {
      //       return PaystackCheckoutScreen(url: paystack.authorizationUrl);
      //     }));
      //   }
      // });
    }
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
