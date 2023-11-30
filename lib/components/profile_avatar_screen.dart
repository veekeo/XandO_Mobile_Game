import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.image,
    required this.imageSize,
    required this.onTap,
  });

  final String image;
  final double imageSize;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: imageSize,
        height: imageSize,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: Image.asset(
              image,
            ).image,
          ),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
