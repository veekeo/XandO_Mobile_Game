import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/models/user_profile_model.dart';
import 'package:xando/screens/Auth_Screens/signin_screen.dart';
import 'package:xando/utils/routers.dart';

class EditProfileProvider extends ChangeNotifier {
  bool _hasError = false;
  bool _isLoading = false;
  String _resMessage = '';
  int _initialBalance = 0;

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  int get initialBalance => _initialBalance;

  //Update Profile Avatar

  Future<void> updateUsername(BuildContext context, String? userId,
      Map<String, String> usernameData) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(usernameData),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        dbProvider.saveUsername(res['username']);
        _resMessage = 'Update successful';
        _hasError = false;
        _isLoading = false;
        notifyListeners();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        final res = json.decode(req.body);
        print(res);
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Update Failed';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _resMessage = 'Internet connection is not available';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _resMessage = e.toString();
      notifyListeners();
    }
  }

  //Edit First name
  Future<void> updateFirstName(BuildContext context, String? userId,
      Map<String, String> firstNameData) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(firstNameData),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        dbProvider.saveUserFirstName(res['first_name']);
        _resMessage = 'Update successful';
        _hasError = false;
        _isLoading = false;
        notifyListeners();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        final res = json.decode(req.body);
        print(res);
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Update Failed';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _resMessage = 'Internet connection is not available';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _resMessage = e.toString();
      notifyListeners();
    }
  }

  //Edit last name
  Future<void> updateLastName(BuildContext context, String? userId,
      Map<String, String> lastNameData) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(lastNameData),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        dbProvider.saveUserlastName(res['last_name']);
        _resMessage = 'Update successful';
        _hasError = false;
        _isLoading = false;
        notifyListeners();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Update Failed';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _resMessage = 'Internet connection is not available';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _resMessage = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateDateOfBirth(BuildContext context, String? userId,
      Map<String, String> dateOfBirthData) async {
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(dateOfBirthData),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        dbProvider.saveUserDateOfBirth(res['date_of_birth']);
        _resMessage = 'Update successful';
        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Update Failed';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _resMessage = 'Internet connection is not available';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _resMessage = e.toString();
      notifyListeners();
    }
  }

  //Get a User

  Future<void> deactivateUserProfile(BuildContext context) async {
    final userId = await DatabaseProvider().getUserId();

    _isLoading = true;
    notifyListeners();

    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        print(res);
        _hasError = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Account Deactivation Failed';
        notifyListeners();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _resMessage = 'Internet connection is not available';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _resMessage = e.toString();
      notifyListeners();
      return Future.error(e.toString());
    }
  }
  //Deactivate Profile

  Future<UserModel> getUserProfileData() async {
    final userId = await DatabaseProvider().getUserId();
    _isLoading = true;
    notifyListeners();

    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        _initialBalance = res['gamedata']['coin'];
        notifyListeners();
        if (json.decode(req.body) == null) {
          return UserModel();
        } else {
          final userModel = userModelFromJson(req.body);
          return userModel;
        }
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Update Failed';
        notifyListeners();
        return UserModel();
      }
    } on SocketException catch (_) {
      _hasError = true;
      _resMessage = 'Internet connection is not available';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _hasError = true;
      _resMessage = e.toString();
      notifyListeners();
      return Future.error(e.toString());
    }
    return UserModel();
  }
}


// dbProvider.userId