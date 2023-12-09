import 'package:flutter/material.dart';
import 'package:flutterflow_ui/flutterflow_ui.dart';

class AvatarContainer extends StatelessWidget {
  const AvatarContainer({
    super.key,
    required this.imageURL,
    required this.isSelected,
    required this.selectedColor,
    required this.onPressed,
  });

  final String imageURL;
  final bool isSelected;
  final Color selectedColor;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: GridTile(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.network(
                imageURL,
              ).image,
            ),
            shape: BoxShape.circle,
            border: Border.all(
              color: isSelected ? const Color(0xff63EA4E) : selectedColor,
              width: 3,
            ),
          ),
        ),
      )),
    );
  }
}
