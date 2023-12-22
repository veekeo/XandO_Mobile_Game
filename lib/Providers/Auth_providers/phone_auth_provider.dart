import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/screens/Auth_Screens/otp_screen.dart';
import 'package:xando/utils/snackbar_message.dart';
import 'package:http/http.dart' as http;

class PhoneNumberAuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _userId;

  bool _isLoading = false;

  String? get userId => _userId;
  bool get isLoading => _isLoading;

  bool _hasError = false;
  bool get hasError => _hasError;

  late String _errorCode;
  String get errorCode => _errorCode;

  Future signInWithPhone(BuildContext context, String phoneNumber) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            _isLoading = false;
            notifyListeners();
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            _hasError = true;
            _isLoading = false;
            _errorCode = error.message.toString();
            notifyListeners();
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            _hasError = false;
            _isLoading = false;
            notifyListeners();
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return OTPScreen(
                  verificationId: verificationId, phoneNumber: phoneNumber);
            }));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
          message: e.message.toString(), context: context, status: true);

      _isLoading = false;
      _hasError = true;
      _errorCode = e.message.toString();
      notifyListeners();
    }
  }

  //verify OTP
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
      _userId = user.uid;
      onSuccess();
    } on FirebaseAuthException catch (e) {
      _errorCode = e.message.toString();
      _isLoading = false;
      notifyListeners();
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
          message: e.message.toString(), context: context, status: true);
    }
  }

  Future<void> saveUserPhoneNumber(BuildContext context, String? userId,
      Map<String, dynamic> updatedData) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(updatedData),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        print(req.statusCode);
        print('User Updated');
        print(res);

        dbProvider.saveUsercontact(res['contact']);

        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
        final res = json.decode(req.body);
        print(req.statusCode);
        print(res);
        _isLoading = false;
        _hasError = true;
        _errorCode = 'Sign in failed';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _errorCode = 'Internet connection is not available';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _errorCode = 'User with the given phone number already exists.';
      print(e.toString());
      notifyListeners();
    }
  }
}
