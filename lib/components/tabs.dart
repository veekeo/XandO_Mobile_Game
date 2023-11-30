import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class SecondTab extends StatelessWidget {
  const SecondTab(
      {super.key,
      required this.selectedTab,
      required this.isSelected,
      required this.tabTitle});

  final Function()? selectedTab;
  final bool isSelected;
  final String tabTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectedTab,
      child: isSelected
          ? Container(
              width: 167,
              height: 35,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 7, 38),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  tabTitle,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 60, 0),
              child: Text(
                tabTitle,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0xB6FFFFFF),
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
            ),
    );
  }
}

class FirstTab extends StatelessWidget {
  const FirstTab({
    super.key,
    required this.selectedTab,
    required this.isSelected,
    required this.tabTitle,
  });

  final Function()? selectedTab;
  final bool isSelected;
  final String tabTitle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: selectedTab,
      child: isSelected
          ? Container(
              width: 167,
              height: 35,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 7, 38),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  tabTitle,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.bold,
                        useGoogleFonts: GoogleFonts.asMap().containsKey(
                            FlutterFlowTheme.of(context).bodyMediumFamily),
                      ),
                ),
              ),
            )
          : Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(60, 0, 0, 0),
              child: Text(
                tabTitle,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Plus Jakarta Sans',
                      color: const Color(0xB6FFFFFF),
                      useGoogleFonts: GoogleFonts.asMap().containsKey(
                          FlutterFlowTheme.of(context).bodyMediumFamily),
                    ),
              ),
            ),
    );
  }
}
