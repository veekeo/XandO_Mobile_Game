import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/avatar_provider.dart';
import 'package:xando/components/avatar_container.dart';
import 'package:xando/utils/snackbar_message.dart';

class AvatarScreen extends StatefulWidget {
  const AvatarScreen({super.key});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen> {
  late String _userId;

  _loadUserData() async {
    String? userId = await DatabaseProvider().getUserId();
    if (mounted) {
      setState(() {
        _userId = userId;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _userId = '';
    _loadUserData();
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
                    'Avatar Gallery',
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
        child: Consumer<AvatarProvider>(
          builder: (context, avatar, child) {
            return Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 13),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3, // Number of columns in the grid
                      crossAxisSpacing: 8.0, // Spacing between columns
                      mainAxisSpacing: 8.0, // Spacing between rows
                    ),
                    itemCount:
                        avatar.avatars.length, // Number of items in the grid
                    itemBuilder: (BuildContext context, int index) {
                      // Build individual grid items here
                      return AvatarContainer(
                        imageURL: avatar.avatars[index].imageURL,
                        isSelected: avatar.avatars[index].isSelected,
                        selectedColor: avatar.avatars[index].selectedColor,
                        onPressed: () {
                          print('user id: $_userId');
                          avatar
                              .updateColor(
                                  context, _userId, avatar.avatars[index])
                              .then((value) {
                            print(_userId);
                            if (avatar.hasError == true) {
                              showErrorSnackBarMessage(
                                message: avatar.resMessage,
                                context: context,
                                status: false,
                              );
                            } else {
                              showSuccessSnackBarMessage(
                                message: avatar.resMessage,
                                context: context,
                                status: true,
                              );
                            }
                          });
                        },
                      );
                    },
                  ),
                ),
                avatar.isLoading
                    ? Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black.withOpacity(0.8),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: FlutterFlowTheme.of(context).primary,
                            value:
                                null, // Set to null for an indeterminate progress indicator
                            strokeWidth: 4.0,
                          ),
                        ),
                      )
                    : const Text(''),
              ],
            );
          },
        ),
      ),
    );
  }
}
