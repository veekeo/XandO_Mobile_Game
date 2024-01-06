import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/models/affilaite_user_model.dart';
import 'package:xando/models/user_profile_model.dart';

class AffliateProvider extends ChangeNotifier {
  bool _hasError = false;
  bool _isLoading = false;
  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  // Base URL
  final String requestbaseUrl = 'https://tictac-production.up.railway.app';

  //Setter

  //Get An Afflitate
  Future<AffliateUserModel> getAffliateUser() async {
    final userId = await DatabaseProvider().getUserId();
    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/affiliate/$userId/';

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        if (json.decode(req.body) == null) {
          return AffliateUserModel();
        } else {
          final affliateUserModel = affliateUserModelFromJson(req.body);
          return affliateUserModel;
        }
      } else {
        _isLoading = false;
        _hasError = true;
        notifyListeners();
      }
    } on SocketException catch (_) {
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      notifyListeners();
    }
    return AffliateUserModel();
  }

  Future<UserModel> getUserProfileDataForHomeScreen() async {
    final userId = await DatabaseProvider().getUserId();

    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        if (json.decode(req.body) == null) {
          return UserModel();
        } else {
          final userModel = userModelFromJson(req.body);
          return userModel;
        }
      } else {
        return UserModel();
      }
    } on SocketException catch (_) {
      _hasError = true;
      notifyListeners();
    } catch (e) {
      notifyListeners();
      return Future.error(e.toString());
    }
    return UserModel();
  }

  void switchAleadyRequested() {
    notifyListeners();
  }
}
