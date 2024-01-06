import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/screens/Auth_Screens/signin_screen.dart';
import 'package:xando/utils/routers.dart';

class DeactivateProfileScreen extends StatefulWidget {
  const DeactivateProfileScreen({super.key});

  @override
  State<DeactivateProfileScreen> createState() =>
      _DeactivateProfileScreenState();
}

class _DeactivateProfileScreenState extends State<DeactivateProfileScreen> {
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
              child: const Row(
                children: [
                  Icon(
                    Icons.chevron_left,
                    size: 30,
                  ),
                  SizedBox(width: 8),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 13),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Align(
                    alignment: const AlignmentDirectional(0.00, 0.00),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
                          child: Text(
                            'Deactivate',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  useGoogleFonts: GoogleFonts.asMap()
                                      .containsKey(FlutterFlowTheme.of(context)
                                          .bodyMediumFamily),
                                ),
                          ),
                        ),
                        Text(
                          'You can use this page to deactivate your account. Deactivation will freeze all of the funds currently in your account, log out anybody currently logged in(including this device), and prevent new logins to account . ',
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                fontFamily: FlutterFlowTheme.of(context)
                                    .bodyMediumFamily,
                                color: const Color(0x89FFFFFF),
                                useGoogleFonts: GoogleFonts.asMap().containsKey(
                                    FlutterFlowTheme.of(context)
                                        .bodyMediumFamily),
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 1.7,
                  ),
                  Consumer<EditProfileProvider>(
                      builder: (context, profile, child) {
                    final dbProvider = context.read<DatabaseProvider>();
                    return PrimaryButton(
                      backgroundColor: const Color(0xFF3B4FFE),
                      title: 'Continue',
                      width: 200,
                      height: 55,
                      onpressed: () async {
                        await profile
                            .deactivateUserProfile(context)
                            .then((value) async {
                          await dbProvider.clearDatabase(context).then(
                              (value) => PageNavigator(ctx: context)
                                  .nextPageOnly(page: const SignInScreen()));
                        });
                      },
                      isLoading: profile.isLoading,
                    );
                  })
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
