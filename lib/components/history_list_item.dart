import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryListItem extends StatelessWidget {
  const HistoryListItem(
      {super.key,
      required this.title,
      required this.gameID,
      required this.date,
      required this.stakeAmount,
      required this.currency,
      required this.stakeAmountinReturn,
      required this.statusColor});

  final String title;
  final String gameID;
  final String date;
  final String stakeAmount;
  final String currency;
  final String stakeAmountinReturn;
  final Color statusColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                textAlign: TextAlign.start,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                gameID,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0x82FFFFFF),
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0x82FFFFFF),
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                stakeAmount,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
              const SizedBox(width: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  currency,
                  width: 15,
                  height: 15,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                stakeAmountinReturn,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontSize: 12,
                      fontFamily: 'Plus Jakarta Sans',
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
              const SizedBox(width: 3),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  currency,
                  width: 15,
                  height: 15,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
