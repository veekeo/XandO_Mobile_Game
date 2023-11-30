// ignore_for_file: library_private_types_in_public_api, must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';
import 'package:google_fonts/google_fonts.dart';

class NumericKeyboard extends StatefulWidget {
  NumericKeyboard({
    super.key,
    required this.input,
  });

  String input;

  @override
  _NumericKeyboardState createState() => _NumericKeyboardState();
}

class _NumericKeyboardState extends State<NumericKeyboard> {
  void _onKeyPressed(String value) {
    setState(() {
      widget.input += value;
    });
  }

  void _onDeletePressed() {
    setState(() {
      if (widget.input.isNotEmpty) {
        widget.input = widget.input.substring(0, widget.input.length - 1);
      }
    });
  }

  void _onClearPressed() {
    setState(() {
      if (widget.input.isNotEmpty) {
        widget.input = '';
      }
    });
  }

  void _onDonePressed() {
  
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      width: double.infinity,
      color: const Color.fromARGB(255, 32, 40, 73),
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i = 1; i <= 6; i++)
                        _buildButton('$i', () => _onKeyPressed('$i')),
                      _deleteButton(() => _onDeletePressed()),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      for (int i = 7; i <= 9; i++)
                        _buildButton('$i', () => _onKeyPressed('$i')),
                      _buildButton('0', () => _onKeyPressed('0')),
                      _buildButton('.', () => _onKeyPressed('.')),
                      _buildButton('00', () => _onKeyPressed('00')),
                      _buildButton('Clear', () => _onClearPressed()),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _onDonePressed();
                },
                child: Container(
                  color: const Color(0xFF3B4FFE),
                  child: Center(
                    child: Text(
                      'Done',
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            fontFamily: 'Plus Jakarta Sans',
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            useGoogleFonts: GoogleFonts.asMap().containsKey(
                                FlutterFlowTheme.of(context).bodyMediumFamily),
                          ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton(String text, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 10),
        child: Text(
          text,
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Plus Jakarta Sans',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                useGoogleFonts: GoogleFonts.asMap()
                    .containsKey(FlutterFlowTheme.of(context).bodyMediumFamily),
              ),
        ),
      ),
    );
  }

  Widget _deleteButton(VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(10.0).copyWith(left: 25),
        child: const Icon(
          Icons.backspace_outlined,
        ),
      ),
    );
  }
}
