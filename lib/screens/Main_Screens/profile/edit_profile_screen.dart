import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Profile/edit_profile_provider.dart';
import 'package:xando/components/user_data_button.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/screens/Main_Screens/profile/avatar_screen.dart';
import 'package:xando/screens/Main_Screens/profile/deactivate_profile.dart';
import 'package:xando/screens/Main_Screens/profile/edit_first_name.dart';
import 'package:xando/screens/Main_Screens/profile/edit_last_name.dart';
import 'package:xando/screens/Main_Screens/profile/edit_user_name.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late UserModel _userId;
  late UserModel userIdFromDB;

  @override
  void initState() {
    super.initState();

    _userId = UserModel();
    userIdFromDB = UserModel();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _getUserIdfromDB();
  }

  _getUserIdfromDB() async {
    userIdFromDB = await EditProfileProvider().getUserProfileData();
    if (mounted) {
      setState(() {
        _userId = userIdFromDB;
      });
    }
  }

  String date = '';
  void getFormattedDate(DateTime newDate) {
    // Convert to local time zone and format using intl package
    setState(() {
      date = DateFormat('yyyy-MM-dd').format(newDate.toLocal());
    });
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: const Color.fromARGB(255, 32, 40, 73),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
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
                    'Profile',
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
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            FutureBuilder<UserModel>(
                future: EditProfileProvider().getUserProfileData(),
                builder: (context, snapshot) {
                  String contactText = snapshot.data?.contact ?? '';
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height /
                          1.2, // Expand to full height
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3B4FFE),
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(context,
                                      CupertinoPageRoute(builder: (context) {
                                    return const AvatarScreen();
                                  }));
                                },
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      0, 0, 0, 10),
                                  child: ClipOval(
                                    child: Container(
                                      width: 100,
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          snapshot.data?.avatar ??
                                              'https://api.multiavatar.com/5b1271f9320afc278a.png',
                                          width: 300,
                                          height: 200,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Text(
                                'Change',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      fontFamily: 'Plus Jakarta Sans',
                                      color: const Color(0xFF3B4FFE),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      useGoogleFonts: GoogleFonts.asMap()
                                          .containsKey(
                                              FlutterFlowTheme.of(context)
                                                  .bodyMediumFamily),
                                    ),
                              ),
                            ],
                          ),
                          UserDataButton(
                            leading: 'Username',
                            trailing: snapshot.data?.username,
                            onPressed: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return EditUserNameScreen(
                                  username: snapshot.data!.username!,
                                );
                              }));
                            },
                          ),
                          divider(),
                          UserDataButton(
                            leading: 'First Name',
                            trailing: snapshot.data?.firstName,
                            onPressed: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return EditFirstNameScreen(
                                  firstname: snapshot.data!.firstName!,
                                );
                              }));
                            },
                          ),
                          divider(),
                          UserDataButton(
                            leading: 'Last Name',
                            trailing: snapshot.data?.lastName,
                            onPressed: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (context) {
                                return EditLastNameScreen(
                                  lastname: snapshot.data!.lastName!,
                                );
                              }));
                            },
                          ),
                          divider(),
                          InkWell(
                            onTap: () {
                              _showDialog(
                                Consumer<EditProfileProvider>(
                                    builder: (context, editProfile, child) {
                                  return CupertinoDatePicker(
                                    // initialDateTime: ,
                                    mode: CupertinoDatePickerMode.date,
                                    use24hFormat: true,
                                    // This is called when the user changes the date.
                                    onDateTimeChanged: (DateTime newDate) {
                                      setState(() {
                                        getFormattedDate(newDate);
                                      });
                                      if (date != '') {
                                        editProfile.updateDateOfBirth(
                                            context,
                                            _userId.id,
                                            {"date_of_birth": date});
                                      }
                                    },
                                  );
                                }),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 15, 0, 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Date of Birth',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: const Color(0xB2FFFFFF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        snapshot.data?.dateOfBirth == null
                                            ? ''
                                            : snapshot.data!.dateOfBirth
                                                .toString(),
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              fontFamily: 'Plus Jakarta Sans',
                                              color: const Color(0xB2FFFFFF),
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              useGoogleFonts: GoogleFonts
                                                      .asMap()
                                                  .containsKey(
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMediumFamily),
                                            ),
                                      ),
                                      const Icon(
                                        Icons.chevron_right,
                                        color: Color(0xB2FFFFFF),
                                        size: 24,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          divider(),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 15, 0, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Phone Number',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: const Color(0xB2FFFFFF),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                                Text(
                                  contactText,
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: const Color(0xB2FFFFFF)
                                            .withOpacity(0.3),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          divider(),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 15, 0, 15),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Safety & Security',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        color: const Color(0xB2FFFFFF)
                                            .withOpacity(0.5),
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          divider(),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  CupertinoPageRoute(builder: (contect) {
                                return const DeactivateProfileScreen();
                              }));
                            },
                            child: Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  0, 15, 0, 15),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Deactivate Account',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          fontFamily: 'Plus Jakarta Sans',
                                          color: const Color(0xB2FFFFFF),
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          useGoogleFonts: GoogleFonts.asMap()
                                              .containsKey(
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMediumFamily),
                                        ),
                                  ),
                                  const Icon(
                                    Icons.chevron_right,
                                    color: Color(0xB2FFFFFF),
                                    size: 24,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          divider(),
                        ],
                      ),
                    );
                  }
                }),
          ],
        ),
      ),
    );
  }

  Container divider() {
    return Container(
      width: double.infinity,
      height: 2,
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 35, 37, 60),
      ),
    );
  }
}
