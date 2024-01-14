import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';

import 'package:http/http.dart' as http;
import 'package:xando/screens/Auth_Screens/otp_screen.dart';

class PhoneNumberAuthProvider extends ChangeNotifier {
  // final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _userId;
  String? _pinId = '';
  bool _isVerified = false;

  bool _isLoading = false;

  String? get userId => _userId;
  bool get isLoading => _isLoading;
  bool get isVerified => _isVerified;

  bool _hasError = false;
  bool get hasError => _hasError;

  late String _errorCode;
  String get errorCode => _errorCode;

  bool? _hasUserGoneThroughOtp = false;
  bool? get hasUserGoneThroughOtp => _hasUserGoneThroughOtp;

  // Future signInWithPhone(BuildContext context, String phoneNumber) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   try {
  //     await _firebaseAuth.verifyPhoneNumber(
  //         phoneNumber: phoneNumber,
  //         verificationCompleted:
  //             (PhoneAuthCredential phoneAuthCredential) async {
  //           _isLoading = false;
  //           notifyListeners();
  //           await _firebaseAuth.signInWithCredential(phoneAuthCredential);
  //         },
  //         verificationFailed: (error) {
  //           print('Error is $error');
  //           _hasError = true;
  //           _isLoading = false;
  //           _errorCode = error.message.toString();
  //           notifyListeners();
  //           throw Exception(error.message);
  //         },
  //         codeSent: (verificationId, forceResendingToken) {
  //           _hasError = false;
  //           _isLoading = false;
  //           notifyListeners();
  //           Navigator.push(context, CupertinoPageRoute(builder: (context) {
  //             return OTPScreen(
  //                 verificationId: verificationId, phoneNumber: phoneNumber);
  //           }));
  //         },
  //         codeAutoRetrievalTimeout: (verificationId) {});
  //   } on FirebaseAuthException catch (e) {
  //     print('Error is e o $e');
  //     // ignore: use_build_context_synchronously
  //     showErrorSnackBarMessage(
  //         message: e.message.toString(), context: context, status: true);

  //     _isLoading = false;
  //     _hasError = true;
  //     _errorCode = e.message.toString();
  //     notifyListeners();
  //   }
  // }

  // //verify OTP
  // void verifyOtp({
  //   required BuildContext context,
  //   required String verificationId,
  //   required String userOtp,
  //   required Function onSuccess,
  // }) async {
  //   _isLoading = true;
  //   notifyListeners();

  //   try {
  //     PhoneAuthCredential creds = PhoneAuthProvider.credential(
  //         verificationId: verificationId, smsCode: userOtp);
  //     User? user = (await _firebaseAuth.signInWithCredential(creds)).user!;
  //     _userId = user.uid;
  //     onSuccess();
  //   } on FirebaseAuthException catch (e) {
  //     _errorCode = e.message.toString();
  //     _isLoading = false;
  //     notifyListeners();
  //     // ignore: use_build_context_synchronously
  //     showErrorSnackBarMessage(
  //         message: e.message.toString(), context: context, status: true);
  //   }
  // }

  Future<void> rememberUserOtp(BuildContext context, bool? isVerified) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    _hasUserGoneThroughOtp = isVerified;
    dbProvider.saveUserRemembrance(hasUserGoneThroughOtp);
    notifyListeners();
  }

  Future<void> signInWithPhone(BuildContext context, String phoneNumber) async {
    _isLoading = true;
    notifyListeners();

    String url = 'https://api.ng.termii.com/api/sms/otp/send';

    var data = {
      "api_key":
          "TLcfd068MjZbhTFTv8ZhUUvY6xuoEjEuCd3jeCDFLmwEI3MnqgSLTAFWjjCrR3",
      "message_type": "NUMERIC",
      "to": phoneNumber,
      "from": "N-Alert",
      "channel": "dnd",
      "pin_attempts": 10,
      "pin_time_to_live": 5,
      "pin_length": 6,
      "pin_placeholder": "< 1234 >",
      "message_text": "Your XandO verification pin is < 1234 >",
      "pin_type": "NUMERIC",
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _pinId = res['pinId'];
        _hasError = false;
        _isLoading = false;
        notifyListeners();

        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushReplacement(CupertinoPageRoute(builder: (context) {
          return OTPScreen(
            phoneNumber: phoneNumber,
          );
        }));
      } else {
        _isLoading = false;
        _hasError = true;
        _errorCode = 'OTP code sending failed. something went wrong.';
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
      _errorCode = 'OTP code sending failed. Try again';
      notifyListeners();
    }
  }

  Future<void> verifyOtp(BuildContext context, String otpCode) async {
    _isLoading = true;
    notifyListeners();

    String url = 'https://api.ng.termii.com/api/sms/otp/verify';

    var data = {
      "api_key":
          "TLcfd068MjZbhTFTv8ZhUUvY6xuoEjEuCd3jeCDFLmwEI3MnqgSLTAFWjjCrR3",
      "pin_id": _pinId,
      "pin": otpCode,
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _isVerified = res['verified'];
        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _errorCode = 'OTP verification failed.';
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
      _errorCode = 'OTP verification failed. Try again';
      notifyListeners();
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

        dbProvider.saveUsercontact(res['contact']);

        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
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

      notifyListeners();
    }
  }
}
