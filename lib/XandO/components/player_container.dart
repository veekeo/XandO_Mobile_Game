import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class Player1Container extends StatelessWidget {
  const Player1Container({
    super.key,
    required this.image,
    required this.indicator,
    required this.isactive,
  });
  final String image;
  final String indicator;

  final bool isactive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFF202849),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        border: Border.all(
          color: isactive ? const Color(0xFF61FD7D) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                indicator,
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class Player2Container extends StatelessWidget {
  const Player2Container({
    super.key,
    required this.image,
    required this.indicator,
    required this.isactive,
  });
  final String image;
  final String indicator;

  final bool isactive;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFF202849),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(50),
          bottomRight: Radius.circular(50),
          topLeft: Radius.circular(50),
          topRight: Radius.circular(50),
        ),
        border: Border.all(
          color: isactive ? Colors.transparent : const Color(0xFFFF4773),
          width: 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 5, 0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset(
                    image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                indicator,
                width: 20,
                height: 20,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
