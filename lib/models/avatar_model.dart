import 'dart:ui';

class AvatarContainerModel {
  final int id;
  final String imageURL;
  final bool isSelected;
  Color selectedColor;

  AvatarContainerModel({
    required this.id,
    required this.imageURL,
    required this.isSelected,
    required this.selectedColor,
  });
}
