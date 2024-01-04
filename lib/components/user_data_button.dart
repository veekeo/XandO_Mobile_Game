import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class UserDataButton extends StatelessWidget {
  const UserDataButton({
    super.key,
    required this.leading,
    required this.trailing,
    this.onPressed,
  });

  final String? leading;
  final String? trailing;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 15, 0, 15),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              leading!,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Plus Jakarta Sans',
                    color: const Color(0xB2FFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    useGoogleFonts: GoogleFonts.asMap().containsKey(
                        FlutterFlowTheme.of(context).bodyMediumFamily),
                  ),
            ),
            Row(
              children: [
                Text(
                  trailing ?? '',
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        color: const Color(0xB2FFFFFF),
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
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
    );
  }
}
