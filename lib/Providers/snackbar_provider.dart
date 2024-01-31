import 'package:flutter/material.dart';

class PointerSnackbarProvider extends ChangeNotifier {
  bool _isVisible = false;

  bool get isVisible => _isVisible;

  void toggleVisibility(bool state) {
    _isVisible = state;
    notifyListeners();
  }
}
