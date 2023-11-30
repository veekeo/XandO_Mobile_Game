import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

void showErrorSnackBarMessage(
    {required String message,
    required BuildContext context,
    required bool status}) {
  Flushbar(
    flushbarStyle: FlushbarStyle.GROUNDED,
    flushbarPosition: FlushbarPosition.TOP,
    reverseAnimationCurve: Curves.easeInOut,
    forwardAnimationCurve: Curves.easeIn,
    backgroundColor: Colors.red,
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Medium',
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
    duration: const Duration(seconds: 4),
  ).show(context);
}

void showSuccessSnackBarMessage(
    {required String message,
    required BuildContext context,
    required bool status}) {
  Flushbar(
    flushbarStyle: FlushbarStyle.GROUNDED,
    flushbarPosition: FlushbarPosition.TOP,
    reverseAnimationCurve: Curves.easeInOut,
    forwardAnimationCurve: Curves.easeIn,
    backgroundColor: Colors.green,
    messageText: Text(
      message,
      style: const TextStyle(
        color: Colors.white,
        fontFamily: 'Medium',
        fontWeight: FontWeight.bold,
        fontSize: 14,
      ),
    ),
    duration: const Duration(seconds: 4),
  ).show(context);
}
