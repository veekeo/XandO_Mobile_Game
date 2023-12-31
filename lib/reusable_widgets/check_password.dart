import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class CheckPassword extends StatelessWidget {
  const CheckPassword({
    super.key,
    required this.isPasswordEightCharacters,
    required this.passwordAtleastHasOneNumber,
    // required this.onPasswordChanged,
  });

  final bool isPasswordEightCharacters;
  final bool passwordAtleastHasOneNumber;

  // final Function(String) onPasswordChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isPasswordEightCharacters
                        ? Colors.green
                        : Colors.transparent,
                    border: isPasswordEightCharacters
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: isPasswordEightCharacters
                          ? Colors.white
                          : Colors.transparent,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Contains at least 8 characters',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: isPasswordEightCharacters
                            ? Colors.white
                            : Colors.grey,
                        fontSize: 14,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodySmallFamily),
                      ),
                )
              ],
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: passwordAtleastHasOneNumber
                        ? Colors.green
                        : Colors.transparent,
                    border: passwordAtleastHasOneNumber
                        ? Border.all(color: Colors.transparent)
                        : Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.check,
                      color: passwordAtleastHasOneNumber
                          ? Colors.white
                          : Colors.transparent,
                      size: 15,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  'Contains at least 1 number',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: passwordAtleastHasOneNumber
                            ? Colors.white
                            : Colors.grey,
                        fontSize: 14,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodySmallFamily),
                      ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
