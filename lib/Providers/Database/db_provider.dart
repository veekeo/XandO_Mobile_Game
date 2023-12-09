import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:xando/screens/Auth_Screens/signin_screen.dart';
import 'package:xando/utils/routers.dart';

class DatabaseProvider extends ChangeNotifier {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  int _coin = 0;
  String _userId = '';
  String _userName = '';
  String _email = '';
  String _contact = '';
  String _firstName = '';
  String _lastName = '';
  String _imageURL = '';

  String get userId => _userId;
  String get userName => _userName;
  String get email => _email;
  String get contact => _contact;
  int get coin => _coin;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get imageURL => _imageURL;

//save user data starts here

  void saveUsername(String? userName) async {
    SharedPreferences value = await _pref;

    value.setString('userName', userName!);
  }
  //.

  void saveUseremail(String? email) async {
    SharedPreferences value = await _pref;

    value.setString('email', email!);
  }
  //.

  void saveUserFirstName(String? firstName) async {
    SharedPreferences value = await _pref;

    value.setString('first_name', firstName!);
  }
  //.

  void saveUserlastName(String? lastName) async {
    SharedPreferences value = await _pref;

    value.setString('last_name', lastName!);
  }

  //.
  void saveUsercontact(String? contact) async {
    SharedPreferences value = await _pref;

    value.setString('contact', contact!);
  }
  //.

  void saveUserId(String? id) async {
    SharedPreferences value = await _pref;

    value.setString('id', id!);
  }
  //.

  void saveUserCoin(int? coin) async {
    SharedPreferences value = await _pref;

    value.setInt('coin', coin!);
  }

  //.
  void saveUserImage(String? imageURL) async {
    SharedPreferences value = await _pref;

    value.setString('imageURL', imageURL!);
  }
  //.

  Future<int> getCoin() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('coin')) {
      int data = value.getInt('coin')!;
      _coin = data;
      notifyListeners();
      return data;
    } else {
      _coin = 0;
      notifyListeners();
      return 0;
    }
  }

  Future<String> getEmail() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('email')) {
      String data = value.getString('email')!;
      _email = data;
      notifyListeners();
      return data;
    } else {
      _email = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getUserName() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('userName')) {
      String data = value.getString('userName')!;
      _userName = data;
      notifyListeners();
      return data;
    } else {
      _userName = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getfirstName() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('first_name')) {
      String data = value.getString('first_name')!;
      _firstName = data;
      notifyListeners();
      return data;
    } else {
      _firstName = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getLastName() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('last_name')) {
      String data = value.getString('last_name')!;
      _lastName = data;
      notifyListeners();
      return data;
    } else {
      _lastName = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getContact() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('contact')) {
      String data = value.getString('contact')!;
      _contact = data;
      notifyListeners();
      return data;
    } else {
      _contact = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getUserId() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('id')) {
      String data = value.getString('id')!;
      _userId = data;
      notifyListeners();
      return data;
    } else {
      _userId = '';
      notifyListeners();
      return '';
    }
  }

  Future<String> getUserImage() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('imageURL')) {
      String data = value.getString('imageURL')!;
      _imageURL = data;
      notifyListeners();
      return data;
    } else {
      _imageURL = '';
      notifyListeners();
      return '';
    }
  }

  void logOut(BuildContext context) async {
    final value = await _pref;

    value.clear();

    // ignore: use_build_context_synchronously
    PageNavigator(ctx: context).nextPageOnly(page: const SignInScreen());
  }
}
