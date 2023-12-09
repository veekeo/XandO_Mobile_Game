import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/utils/snackbar_message.dart';

class EditLastNameScreen extends StatefulWidget {
  const EditLastNameScreen({super.key, required this.lastname});
  final String lastname;

  @override
  State<EditLastNameScreen> createState() => _EditLastNameScreenState();
}

class _EditLastNameScreenState extends State<EditLastNameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      _lastNameController.text = widget.lastname;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _lastNameController.text = widget.lastname;
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
                    'Edit Last Name',
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
      body: SafeArea(
        top: true,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    autofocus: true,
                    controller: _lastNameController,
                    onChanged: (value) => EasyDebounce.debounce(
                      '_lastnameController',
                      const Duration(milliseconds: 2000),
                      () => setState(() {}),
                    ),
                    textCapitalization: TextCapitalization.none,
                    decoration: customInputDecoration(
                      context: context,
                      hintText: 'Enter Last Name',
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
                const SizedBox(height: 20),
                Consumer<EditProfileProvider>(
                  builder: (context, editProfile, child) {
                    return PrimaryButton(
                      title: 'Save',
                      width: 200,
                      height: 55,
                      onpressed: () {
                        final dbProvider = context.read<DatabaseProvider>();
                        if (_formKey.currentState?.validate() ?? false) {
                          editProfile.updateLastName(
                              context, dbProvider.userId, {
                            'last_name': _lastNameController.text.trim()
                          }).then((value) {
                            if (editProfile.hasError == true) {
                              showErrorSnackBarMessage(
                                message: editProfile.resMessage,
                                context: context,
                                status: false,
                              );
                            } else {
                              showSuccessSnackBarMessage(
                                message: editProfile.resMessage,
                                context: context,
                                status: true,
                              );
                            }
                          });
                        } else {
                          showErrorSnackBarMessage(
                            message: 'Field cannot be empty',
                            context: context,
                            status: false,
                          );
                        }
                      },
                      isLoading: editProfile.isLoading,
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
