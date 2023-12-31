import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/Providers/get_banks_code_provider.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/Providers/paystack_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/models/banks_code_model.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/utils/snackbar_message.dart';

class Withdraw extends StatefulWidget {
  const Withdraw({super.key});

  @override
  State<Withdraw> createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  final TextEditingController _transferAmountController =
      TextEditingController();
  final TextEditingController _accountNumberController =
      TextEditingController();
  String _selectedBank = '';
  String _bankCode = '';

  void _updateSelectedBank(String bankName, String bankCode) {
    setState(() {
      _selectedBank = bankName;
      _bankCode = bankCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 15),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
              child: FutureBuilder<UserModel>(
                future: EditProfileProvider().getUserProfileData(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
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
                                    padding:
                                        const EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 8),
                                    child: Text(
                                      '${snapshot.data!.gamedata?.coin} NGN',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            fontFamily: 'Plus Jakarta Sans',
                                            fontSize: 32,
                                            fontWeight: FontWeight.bold,
                                            useGoogleFonts: GoogleFonts.asMap()
                                                .containsKey(
                                                    FlutterFlowTheme.of(context)
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
            GestureDetector(
              onTap: () {
                _showBottomSheet(context);
              },
              child: Align(
                alignment: const AlignmentDirectional(0.00, 0.00),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                  child: Material(
                    color: Colors.transparent,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Container(
                      width: double.infinity,
                      height: 45,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 0, 7, 38),
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          color: const Color(0x92FFFFFF),
                          width: 1,
                        ),
                      ),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 20, 0),
                                  child: Icon(
                                    Icons.account_balance_outlined,
                                    color: Color(0xB1FFFFFF),
                                    size: 24,
                                  ),
                                ),
                                Text(
                                  _selectedBank == ''
                                      ? 'Select a Bank'
                                      : _selectedBank,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: const Color(0xB2FFFFFF),
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.keyboard_arrow_right,
                              color: Color(0xB3FFFFFF),
                              size: 24,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            TextFormField(
              controller: _accountNumberController,
              onChanged: (value) {
                setState(() {
                  _accountNumberController.text = value;
                });
              },
              cursorColor: const Color(0xFF3B4FFE),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(19),
              ],
              decoration: InputDecoration(
                hintText: "Account Number",
                labelText: 'Account Number',
                labelStyle: FlutterFlowTheme.of(context).labelMedium,
                hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0x84FFFFFF),
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).labelMediumFamily),
                    ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
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
                prefixIcon: const Icon(
                  Icons.account_circle_outlined,
                  color: Color(0xB1FFFFFF),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: const AlignmentDirectional(0.00, 0.00),
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15),
                child: Material(
                  color: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Container(
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 7, 38),
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        color: FlutterFlowTheme.of(context).primary,
                        width: 1,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(bottom: 5, left: 10),
                                child: Text(
                                  'Amount NGN',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        color: const Color(0xB1FFFFFF),
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  8, 0, 8, 0),
                              child: TextFormField(
                                controller: _transferAmountController,
                                onChanged: (value) {
                                  setState(() {
                                    _transferAmountController.text = value;
                                  });
                                },
                                textCapitalization: TextCapitalization.none,
                                obscureText: false,
                                decoration: InputDecoration(
                                  hintText: 'MIN. 1',
                                  hintStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: const Color(0x75FFFFFF),
                                        fontSize: 14,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .titleMediumFamily),
                                      ),
                                  errorStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color:
                                            FlutterFlowTheme.of(context).error,
                                        fontSize: 14,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedErrorBorder: InputBorder.none,
                                  contentPadding:
                                      const EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 17),
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 14,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                                textAlign: TextAlign.end,
                                maxLength: 11,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                buildCounter: (context,
                                        {required currentLength,
                                        required isFocused,
                                        maxLength}) =>
                                    null,
                                keyboardType: TextInputType.phone,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            PrimaryButton(
              backgroundColor: const Color(0xFF3B4FFE),
              title: 'Withdraw',
              width: 200,
              height: 55,
              onpressed: () {
                if (_selectedBank == '') {
                  showErrorSnackBarMessage(
                    message: 'Please Select a Bank for Transfer.',
                    context: context,
                    status: false,
                  );
                } else if (_accountNumberController.text == '') {
                  showErrorSnackBarMessage(
                    message: 'Please Enter Account Number.',
                    context: context,
                    status: false,
                  );
                } else if (_transferAmountController.text == '') {
                  showErrorSnackBarMessage(
                    message: 'Please an amount.',
                    context: context,
                    status: false,
                  );
                  //Dont forget to make sure the user does not transfer more than what they have as their balance
                } else {
                  handleTransfer().then((value) {
                    setState(() {
                      _transferAmountController.text = '';
                    });
                  });
                }
              },
              isLoading: Provider.of<PaystackProvider>(context, listen: true)
                  .isLoading,
            ),
            const SizedBox(height: 10),
            Align(
              alignment: const AlignmentDirectional(-1.00, 0.00),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Text(
                      '1. Minimum per transaction is NGN 1.00.',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            color: const Color(0xB3FFFFFF),
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 8),
                    child: Text(
                      '2. Maximum per transaction is NGN 9,999,999.00.',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            color: const Color(0xB3FFFFFF),
                            fontWeight: FontWeight.normal,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
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

  Future handleTransfer() async {
    final paystack = context.read<PaystackProvider>();
    //internet provider
    final internetProvider = context.read<InternetProvider>();

    await internetProvider.checkInternetConnection();
    if (internetProvider.hasInternet == false) {
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else {
      await paystack
          .createTransferRecipient(_accountNumberController.text, _bankCode)
          .then((value) {
        if (paystack.transferStatus == false) {
          showErrorSnackBarMessage(
            message: paystack.resMessage,
            context: context,
            status: false,
          );
        } else {
          paystack
              .initiateTransfer(_transferAmountController.text)
              .then((value) {
            if (paystack.transferStatus == false) {
              showErrorSnackBarMessage(
                message: paystack.resMessage,
                context: context,
                status: false,
              );
            } else {
              showSuccessSnackBarMessage(
                message: paystack.resMessage,
                context: context,
                status: true,
              );
            }
          });
        }
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 16, 20, 37),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 35,
                  height: 5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 73, 84, 129),
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                const SizedBox(height: 16.0),
                FutureBuilder<List<BanksCodeModel>>(
                  future: GetBanksCode().getBanksCode(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return SizedBox(
                        height: MediaQuery.of(context).size.height /
                            4, // Expand to full height
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF3B4FFE),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return BankColumn(
                                logo: snapshot.data![index].logo,
                                name: snapshot.data![index].name,
                                onPressed: () {
                                  _updateSelectedBank(
                                      snapshot.data![index].name,
                                      snapshot.data![index].code);
                                  Navigator.pop(context);
                                },
                              );
                            }),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BankColumn extends StatelessWidget {
  const BankColumn({
    super.key,
    required this.logo,
    required this.name,
    required this.onPressed,
  });

  final String logo;
  final String name;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 18),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    logo,
                    width: 90,
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  name,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        fontSize: 16,
                        color: Colors.grey,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                ),
              ],
            ),
          ),
          Container(
            width: 500,
            height: 1,
            color: const Color.fromARGB(255, 73, 84, 129),
          )
        ],
      ),
    );
  }
}
