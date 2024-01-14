import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/main_page.dart';
import 'package:xando/screens/Auth_Screens/add_phone_number_screen.dart';
import 'package:xando/screens/Auth_Screens/signin_screen.dart';
import 'package:xando/utils/routers.dart';
import 'package:provider/provider.dart';
import 'package:email_otp/email_otp.dart';

class AuthenticationProvider extends ChangeNotifier {
  // Base URL
  final String requestbaseUrl = 'https://tictac-production.up.railway.app';
  EmailOTP emailAuth = EmailOTP();

  //Setter

  bool _isLoading = false;
  String _resMessage = '';
  bool? _rememberUser = false;

  bool _alreadyRequested = false;

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  bool? get rememberUser => _rememberUser;

  bool get alreadyRequested => _alreadyRequested;

  void registerUser({
    BuildContext? context,
    required String email,
    required String password,
    required String affliateCode,
  }) async {
    _isLoading = true;
    notifyListeners();

    final dbProvider = Provider.of<DatabaseProvider>(context!, listen: false);

    String url = '$requestbaseUrl/tictac/sign-up/';

    final body = {
      "email": email,
      "password": password,
      "affiliate_code": affliateCode,
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'});

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        dbProvider.saveUsername(res['username']);
        dbProvider.saveUserId(res['id']);
        // dbProvider.saveUserCoin(res['coin']);
        dbProvider.saveUseremail(res['email']);
        dbProvider.saveUserFirstName(res['first_name']);
        dbProvider.saveUserlastName(res['last_name']);

        _isLoading = false;
        _resMessage = 'Account created';
        notifyListeners();
        // ignore: use_build_context_synchronously
        PageNavigator(ctx: context).nextPageOnly(page: const SignInScreen());
      } else if (req.statusCode == 400) {
        _isLoading = false;
        _resMessage = 'Invalid Affliate Code.';
        notifyListeners();
      } else {
        _resMessage = 'User with this email already exists';
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = 'Internet Connection is not available';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = 'Please try again!';
      notifyListeners();
    }
  }

  //.

  //.

  //.

  //.

  //.

  //.

  //.

  ///Login goes here

  void loginUser(
      {BuildContext? context,
      required String email,
      required String password}) async {
    _isLoading = true;
    notifyListeners();

    String url = '$requestbaseUrl/gamer/sign-in';

    final dbProvider = Provider.of<DatabaseProvider>(context!, listen: false);

    final body = {
      "email": email,
      "password": password,
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'});

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        dbProvider.saveUsername(res['user_data']['username']);
        dbProvider.saveUserId(res['user_data']['id']);
        dbProvider.saveUserCoin(res['user_data']['coin']);
        dbProvider.saveUseremail(res['user_data']['email']);
        dbProvider.saveUserFirstName(res['user_data']['first_name']);
        dbProvider.saveUserlastName(res['user_data']['last_name']);

        _isLoading = false;
        _resMessage = 'Login Successful';
        notifyListeners();
        // ignore: use_build_context_synchronously
        dbProvider.getUserOtpRemembrance().then(
          (value) {
            if (value == true) {
              Navigator.of(context)
                  .pushReplacement(CupertinoPageRoute(builder: (context) {
                return const MainPage();
              }));
            } else {
              Navigator.of(context)
                  .pushReplacement(CupertinoPageRoute(builder: (context) {
                return const AddPhoneNumberScreen();
              }));
            }
          },
        );
      } else {
        _resMessage = 'Invalid Email or Password';
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = 'Internet Connection is not available';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = 'Please try again!';
      notifyListeners();
    }
  }

  Future<void> rememberMe(BuildContext context, bool? ischecked) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    _rememberUser = ischecked;
    dbProvider.saveUserRemembrance(rememberUser);
    notifyListeners();
  }

  void clear() {
    _resMessage = '';
    notifyListeners();
  }

  //Forgot Password-------------------------------------------------------------------------------------------------------------------]
  Future<bool> sendEmailOTP(String userEmail) async {
    _isLoading = true;
    notifyListeners();
    try {
      emailAuth.setConfig(
          appEmail: "xo@animationhub.ng",
          appName: "XandO Animation Hub",
          userEmail: userEmail,
          otpLength: 6,
          otpType: OTPType.digitsOnly);
      bool res = await emailAuth.sendOTP();

      if (res) {
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = 'Internet Connection is not available';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = 'Please try again!';
      notifyListeners();
    }
    return false;
  }

  ///...

  Future verifyEmailOTP(dynamic otp) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (await emailAuth.verifyOTP(otp: otp.text) == true) {
        _isLoading = false;
        _resMessage = 'OTP verification successful.';
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        _resMessage = 'OTP verification failed.';
        notifyListeners();
        return false;
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = 'Internet Connection is not available';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = 'Please try again!';
      notifyListeners();
    }
  }

  ///........................

  Future<void> changePassword(
    BuildContext? context,
    String userEmail,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    String url = '$requestbaseUrl/gamer/change_password/';

    final body = {
      "email": userEmail,
      "new_password": password,
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'});

      if (req.statusCode == 200 || req.statusCode == 201) {
        _isLoading = false;
        _resMessage = 'Password changed!';
        notifyListeners();
      } else {
        _resMessage = 'Something went wrong, try again.';
        _isLoading = false;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = 'Internet Connection is not available';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = 'Please try again!';
      notifyListeners();
    }
  }

  void switchAleadyRequested() {
    _alreadyRequested = true;
    notifyListeners();
  }
}
