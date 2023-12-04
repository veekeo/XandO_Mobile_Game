import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xando/screens/Auth_Screens/add_phone_number_screen.dart';
import 'package:xando/utils/routers.dart';

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
        _isLoading = false;
        _resMessage = 'Account created';
        notifyListeners();
        // ignore: use_build_context_synchronously
        PageNavigator(ctx: context)
            .nextPageOnly(page: const AddPhoneNumberScreen());
      } else {
        final res = json.decode(req.body);
        print(res);
        print(req.statusCode);
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

  ///Login goes here

  void loginUser({
    BuildContext? context,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    notifyListeners();

    String url = '$requestbaseUrl/gamer/sign-in';

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
        _isLoading = false;
        _resMessage = 'Login Successful';
        notifyListeners();
        // ignore: use_build_context_synchronously
        PageNavigator(ctx: context)
            .nextPageOnly(page: const AddPhoneNumberScreen());
      } else {
        final res = json.decode(req.body);
        print(res);

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
