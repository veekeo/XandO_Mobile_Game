import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:xando/Providers/firestore_service.dart';
import 'package:xando/components/primary_button.dart';
import 'package:xando/utils/dynamic_links.dart';

// ignore: must_be_immutable
class UserGameDetailsScreen extends StatefulWidget {
  UserGameDetailsScreen({
    super.key,
    required this.isRequested,
    required this.stake,
    required this.potentialWin,
    required this.gameTitle,
    required this.gameId,
    required this.username,
    required this.state,
  });

  final String? stake;
  String potentialWin;
  final String? gameTitle;
  final String? gameId;
  final String? username;
  final bool? isRequested;
  final bool state;

  @override
  State<UserGameDetailsScreen> createState() => _UserGameDetailsScreenState();
}

class _UserGameDetailsScreenState extends State<UserGameDetailsScreen> {
  double? calculateDiscount(double stake) {
    // Calculate the sum of the two equal numbers
    double sum = 2 * stake;

    // Calculate 20% off the sum
    double discount = 0.20 * sum;

    // Calculate the final discounted value
    double discountedValue = sum - discount;

    return discountedValue;
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
                    'Game Details',
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
        child: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16.0),
              const Text(
                'Preview game',
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'Bold',
                ),
              ),
              const SizedBox(height: 7),
              Text(
                'You can copy or share this game, \nand we will notify you when you have \na request.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Medium',
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Username',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '${widget.username}',
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
                    'Stake',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    'NGN ${widget.stake}',
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
                    'NGN ${calculateDiscount(double.parse(widget.potentialWin)).toString()}',
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
                    'Title',
                    style: TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  Text(
                    '${widget.gameTitle}',
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
                    '${widget.gameId}',
                    style: const TextStyle(
                      fontFamily: 'Medium',
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Consumer<DynamicLinksProvider>(builder: (context, links, child) {
                return PrimaryButton(
                  backgroundColor: const Color(0xFF3B4FFE),
                  title: 'Share',
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  onpressed: widget.state
                      ? () {
                          links.createGameLink(widget.gameId).then((value) {
                            Share.share(value);
                          });
                        }
                      : null,
                  isLoading: false,
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
