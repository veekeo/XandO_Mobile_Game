import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:xando/screens/Auth_Screens/otp_screen.dart';
import 'package:xando/utils/snackbar_message.dart';

class PhoneNumberAuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String? _userId;

  bool _isLoading = false;

  String? get userId => _userId;
  bool get isLoading => _isLoading;

  void signInWithPhone(BuildContext context, String phoneNumber) async {
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
            _isLoading = false;
            notifyListeners();
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            _isLoading = false;
            notifyListeners();
            Navigator.push(context, CupertinoPageRoute(builder: (context) {
              return OTPScreen(verificationId: verificationId);
            }));
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
          message: e.message.toString(), context: context, status: true);
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
      _isLoading = false;
      notifyListeners();
      // ignore: use_build_context_synchronously
      showErrorSnackBarMessage(
          message: e.message.toString(), context: context, status: true);
    }
  }

  // FirebaseAuth auth = FirebaseAuth.instance;
  // String resendCodeText = 'RESEND CODE';
  // bool isSending = false;
  // String myVerificationId = '';

  // // late Timer _codeTimer;

  // // Timer get codeTimer => _codeTimer;

  // //verify Phone number

  // void verifyPhoneNumber(BuildContext context, String phone) async {
  //   isSending = true;
  //   notifyListeners();

  //   await auth.verifyPhoneNumber(
  //     phoneNumber: phone,
  //     verificationCompleted: (PhoneAuthCredential credential) async {
  //       await auth.signInWithCredential(credential);
  //       // ignore: use_build_context_synchronously
  //       PageNavigator(ctx: context).nextPageOnly(page: MainPage());
  //     },
  //     timeout: const Duration(seconds: 60),
  //     verificationFailed: (FirebaseException error) {
  //       if (error.code == 'invalid-phone-number') {
  //         isSending = false;
  //         notifyListeners();
  //         showErrorSnackBarMessage(
  //             message: 'Invalid Phone number, try again',
  //             context: context,
  //             status: true);
  //       } else {
  //         isSending = false;
  //         notifyListeners();
  //         showErrorSnackBarMessage(
  //             message: 'Error, something went wrong',
  //             context: context,
  //             status: true);
  //       }
  //     },
  //     codeSent: (String verificationId, int? forceResendingToken) {
  //       myVerificationId = verificationId;
  //       notifyListeners();
  //     },
  //     codeAutoRetrievalTimeout: (String verificationId) {
  //       myVerificationId = verificationId;
  //       isSending = false;
  //       notifyListeners();
  //     },
  //   );
  // }

  // //verify sms
  // Future<bool> verifySmsCode(BuildContext context, String otp) async {
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: myVerificationId, smsCode: otp);

  //   var credentials = await auth.signInWithCredential(credential);
  //   return credentials.user != null ? true : false;
  // }
}
