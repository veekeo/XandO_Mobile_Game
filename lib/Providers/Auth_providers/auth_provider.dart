import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/screens/Auth_Screens/add_phone_number_screen.dart';
import 'package:xando/utils/routers.dart';
import 'package:provider/provider.dart';

class AuthenticationProvider extends ChangeNotifier {
  // Base URL
  final String requestbaseUrl = 'https://tictac-production.up.railway.app';

  //Setter

  bool _isLoading = false;
  String _resMessage = '';

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  void registerUser({
    BuildContext? context,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    final dbProvider = Provider.of<DatabaseProvider>(context!, listen: false);

    String url = '$requestbaseUrl/tictac/sign-up/';

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
        _resMessage = 'Account created';
        notifyListeners();
        // ignore: use_build_context_synchronously
        PageNavigator(ctx: context)
            .nextPageOnly(page: const AddPhoneNumberScreen());
      } else {
        // final res = json.decode(req.body);
        // print(res);
        // print(req.statusCode);
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

  void loginUser({
    BuildContext? context,
    required String email,
    required String password,
  }) async {
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
        print(res);

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
        PageNavigator(ctx: context)
            .nextPageOnly(page: const AddPhoneNumberScreen());
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

  void clear() {
    _resMessage = '';
    notifyListeners();
  }
}
