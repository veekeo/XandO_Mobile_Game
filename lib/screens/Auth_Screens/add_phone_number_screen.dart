import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Auth_providers/phone_auth_provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/internet_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/utils/snackbar_message.dart';

class AddPhoneNumberScreen extends StatefulWidget {
  const AddPhoneNumberScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AddPhoneNumberScreenState createState() => _AddPhoneNumberScreenState();
}

class _AddPhoneNumberScreenState extends State<AddPhoneNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneNumberController = TextEditingController();
  final String _ngDailCode = '+234';

  @override
  Widget build(BuildContext context) {
    bool isLoading =
        Provider.of<PhoneNumberAuthProvider>(context, listen: true).isLoading;
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        top: true,
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/images/3d_mobile_lock.png',
                    width: 255,
                    height: 255,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Text(
                      'Verify Your \nPhone Number',
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
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                    child: Text(
                      'Verify your phone number for enhanced \nsecurity and seamless\ncommunication during signup!',
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
                const SizedBox(height: 5),
                Align(
                  alignment: const AlignmentDirectional(0.00, 0.00),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(5, 5, 5, 5),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                8, 0, 8, 2),
                            child: Form(
                              key: _formKey,
                              child: TextFormField(
                                autofocus: true,
                                controller: _phoneNumberController,
                                onChanged: (_) => EasyDebounce.debounce(
                                  '_model.textController',
                                  const Duration(milliseconds: 2000),
                                  () => setState(() {}),
                                ),
                                textCapitalization: TextCapitalization.none,
                                obscureText: false,
                                decoration: customInputDecoration(
                                  context: context,
                                  hintText: '8145274634',
                                  prefix: prefixRow(),
                                  suffix: _phoneNumberController.text.isNotEmpty
                                      ? InkWell(
                                          onTap: () async {
                                            _phoneNumberController.clear();
                                            setState(() {});
                                          },
                                          child: const Icon(
                                            Icons.clear,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        )
                                      : null,
                                ),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      fontSize: 16,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                                textAlign: TextAlign.start,
                                maxLength: 10,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                buildCounter: (context,
                                        {required currentLength,
                                        required isFocused,
                                        maxLength}) =>
                                    null,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                maxLines: 1,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.toString().length < 10) {
                                    return 'Enter a valid Phone number';
                                  }

                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: PrimaryButton(
                    backgroundColor: const Color(0xFF3B4FFE),
                    title: 'Send OTP',
                    width: 200,
                    height: 55,
                    onpressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        Provider.of<DatabaseProvider>(context, listen: false)
                            .getUserId()
                            .then(
                              (value) {},
                            );
                        sendPhoneNumber();
                      } else {
                        setState(() {
                          isLoading = false;
                        });
                        showErrorSnackBarMessage(
                            message: 'Please enter your mobile number',
                            context: context,
                            status: true);
                      }
                    },
                    isLoading: isLoading,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void sendPhoneNumber() async {
    final ap = Provider.of<PhoneNumberAuthProvider>(context, listen: false);

    //internet provider
    final internetProvider = context.read<InternetProvider>();
    await internetProvider.checkInternetConnection();
    String phoneNumber = _ngDailCode + _phoneNumberController.text.trim();

    if (internetProvider.hasInternet == false) {
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
        message: 'Please check your internet connection',
        context: context,
        status: false,
      );
    } else {
      // ignore: use_build_context_synchronously
      ap.signInWithPhone(context, phoneNumber);
    }
  }

  //input decoration

  InputDecoration customInputDecoration({
    required BuildContext context,
    required String hintText,
    required Widget? prefix,
    required Widget? suffix,
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
      prefixIcon: prefix,
      suffixIcon: suffix,
    );
  }

  Widget prefixRow() {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 20,
            width: 27,
            child: Image.asset(
              'assets/images/ng_flag.png',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 3),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 10, 0),
            child: Text(
              "+234",
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyMediumFamily),
                  ),
            ),
          ),
          Opacity(
            opacity: 0.4,
            child: Container(
              width: 2,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
