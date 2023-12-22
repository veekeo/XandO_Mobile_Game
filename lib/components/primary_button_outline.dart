import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.title,
    required this.width,
    required this.height,
    required this.onpressed,
    required this.isLoading,
  });

  final String title;
  final double width;
  final double height;
  final Function()? onpressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: isLoading ? null : onpressed,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              const Color.fromARGB(255, 32, 40, 73), // Background color
          foregroundColor: Colors.white, // Text color
          // padding: EdgeInsets.symmetric(horizontal: width, vertical: height),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),

          elevation: 0, // Elevation (shadow)
        ),
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: FlutterFlowTheme.of(context).primary,
                  value:
                      null, // Set to null for an indeterminate progress indicator
                  strokeWidth: 4.0,
                ),
              )
            : Text(
                title,
                style: FlutterFlowTheme.of(context).headlineSmall.override(
                      fontFamily: 'Plus Jakarta Sans',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).headlineSmallFamily),
                    ),
              ),
      ),
    );
  }
}
