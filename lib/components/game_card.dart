import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class GameCard extends StatelessWidget {
  const GameCard({
    super.key,
    required this.image,
    required this.username,
    required this.price,
    required this.buttonText,
    required this.onTap,
    required this.cardColor,
    required this.state,
    required this.onCardTap,
  });

  final String? image;
  final String? username;
  final String? price;
  final String buttonText;
  final Function()? onTap;
  final Function()? onCardTap;
  final Color cardColor;
  final bool state;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13.0),
        child: Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 8, 15, 8),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: Image.network(
                            image!,
                          ).image,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                      child: Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                        child: Text(
                          username!,
                          maxLines: 1,
                          style: const TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        'assets/images/naira_coin.png',
                        width: 15,
                        height: 15,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 0, 0),
                      child: Text(
                        price!,
                        style: const TextStyle(
                          fontFamily: 'Medium',
                          fontSize: 12,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                FFButtonWidget(
                  onPressed: state ? onTap : null,
                  text: buttonText,
                  options: FFButtonOptions(
                    width: 74,
                    height: 29,
                    padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                    iconPadding:
                        const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    color: state
                        ? FlutterFlowTheme.of(context).primary
                        : const Color.fromARGB(255, 32, 40, 73),
                    textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                          fontFamily: 'Plus Jakarta Sans',
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          useGoogleFonts: GoogleFonts.asMap().containsKey(
                              FlutterFlowTheme.of(context).titleSmallFamily),
                        ),
                    elevation: 0,
                    borderSide: const BorderSide(
                      color: Colors.transparent,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
