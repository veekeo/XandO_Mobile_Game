import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/Providers/Game/create_game_provider.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/components/primary_button_outline.dart';
import 'package:xando/utils/dynamic_links.dart';
import 'package:xando/utils/snackbar_message.dart';
import 'package:rive/rive.dart';

class CreateGameScreen extends StatefulWidget {
  const CreateGameScreen({super.key});

  @override
  State<CreateGameScreen> createState() => _CreateGameScreenState();
}

class _CreateGameScreenState extends State<CreateGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _gameTitleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _stake = 0;

  //Rive

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
                    'Create a Game',
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
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Align(
                alignment: const AlignmentDirectional(-0.03, 0.00),
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Align(
                              alignment:
                                  const AlignmentDirectional(-1.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 10),
                                child: Text(
                                  'Game Title',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 15, 5),
                              child: TextFormField(
                                autofocus: true,
                                controller: _gameTitleController,
                                onChanged: (value) => EasyDebounce.debounce(
                                  '_gameTitleController',
                                  const Duration(milliseconds: 2000),
                                  () => setState(() {}),
                                ),
                                textCapitalization: TextCapitalization.none,
                                decoration: customInputDecoration(
                                  context: context,
                                  hintText: 'Enter a Game Title',
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
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                maxLines: 1,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Game title cannot be empty';
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Align(
                              alignment:
                                  const AlignmentDirectional(-1.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 10),
                                child: Text(
                                  'Amount',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 15, 5),
                              child: TextFormField(
                                autofocus: true,
                                controller: _amountController,
                                onChanged: (value) {
                                  if (value.length >= 2) {
                                    Provider.of<CreateGameProvider>(context,
                                            listen: false)
                                        .calculateDiscount(double.parse(value));
                                    setState(() {
                                      _stake = double.parse(value);
                                    });
                                  } else {
                                    return;
                                  }
                                },
                                textCapitalization: TextCapitalization.none,
                                decoration: customInputDecoration(
                                  context: context,
                                  hintText: '100',
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
                                maxLength: 9,
                                maxLengthEnforcement:
                                    MaxLengthEnforcement.enforced,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                maxLines: 1,
                                cursorColor:
                                    FlutterFlowTheme.of(context).primary,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Stake cannot be empty';
                                  }
                                  if (value.length < 2 ||
                                      value.startsWith('0')) {
                                    return 'Stake of that amount is not allowed';
                                  }

                                  return null;
                                },
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[0-9]'))
                                ],
                              ),
                            ),
                            Align(
                              alignment:
                                  const AlignmentDirectional(-1.00, 0.00),
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    15, 0, 15, 10),
                                child: Text(
                                  'Potential Win',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        fontFamily: 'Plus Jakarta Sans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                        useGoogleFonts: GoogleFonts.asMap()
                                            .containsKey(
                                                FlutterFlowTheme.of(context)
                                                    .bodyMediumFamily),
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(
                                  15, 0, 15, 5),
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 32, 40, 73),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 0, 10, 0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Opacity(
                                            opacity: 0.7,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.asset(
                                                'assets/images/naira_coin.png',
                                                width: 22,
                                                height: 22,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(5, 0, 0, 0),
                                            child: Text(
                                              Provider.of<CreateGameProvider>(
                                                      context,
                                                      listen: true)
                                                  .potentialWin
                                                  .toString(),
                                              textAlign: TextAlign.start,
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    fontFamily:
                                                        'Plus Jakarta Sans',
                                                    color:
                                                        const Color(0xBAFFFFFF),
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
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 15),
                            Consumer<CreateGameProvider>(
                              builder: (context, creategame, child) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: PrimaryButton(
                                    backgroundColor: const Color(0xFF3B4FFE),
                                    title: 'Create Game',
                                    width: double.infinity,
                                    height: 55,
                                    onpressed: () async {
                                      final userId =
                                          await DatabaseProvider().getUserId();
                                      if (_formKey.currentState?.validate() ??
                                          false) {
                                        print(userId);
                                        // ignore: use_build_context_synchronously
                                        creategame
                                            .createGame(
                                                context,
                                                userId,
                                                _gameTitleController.text
                                                    .trim(),
                                                _stake.toString().trim())
                                            .then((value) {
                                          if (creategame.hasError == true) {
                                            showErrorSnackBarMessage(
                                              message: creategame.resMessage,
                                              context: context,
                                              status: false,
                                            );
                                          } else {
                                            _showBottomSheet(
                                              context: context,
                                              potentialWin: creategame
                                                  .potentialWin
                                                  .toString(),
                                              stake: creategame.stake,
                                              gameId:
                                                  creategame.gameId.toString(),
                                            );
                                            showSuccessSnackBarMessage(
                                              message: creategame.resMessage,
                                              context: context,
                                              status: false,
                                            );
                                          }
                                        });
                                      } else {
                                        // ignore: use_build_context_synchronously
                                        showErrorSnackBarMessage(
                                          message:
                                              'Please fill in the required fields!',
                                          context: context,
                                          status: false,
                                        );
                                      }
                                    },
                                    isLoading: creategame.isLoading,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBottomSheet({
    required BuildContext context,
    required String? stake,
    required String? gameId,
    required String? potentialWin,
  }) {
    showModalBottomSheet(
      backgroundColor: const Color.fromARGB(255, 16, 20, 37),
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height / 2.2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
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
                const SizedBox(
                  width: 130,
                  height: 100,
                  child: RiveAnimation.asset(
                    'assets/images/success.riv',
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  'Bet Successful',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Bold',
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Stake',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      'NGN ${stake!}',
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Potential win',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      potentialWin!,
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Game ID',
                      style: TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Text(
                      gameId!,
                      style: const TextStyle(
                        fontFamily: 'Medium',
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SecondaryButton(
                      title: 'Close',
                      width: 140,
                      height: 50,
                      onpressed: () {
                        Navigator.pop(context);
                      },
                      isLoading: false,
                    ),
                    Consumer<DynamicLinksProvider>(
                        builder: (context, link, child) {
                      return PrimaryButton(
                        backgroundColor: const Color(0xFF3B4FFE),
                        title: 'Share',
                        width: 140,
                        height: 50,
                        onpressed: () {
                          link.createGameLink(gameId).then((value) {
                            Share.share(value);
                          });
                        },
                        isLoading: false,
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
