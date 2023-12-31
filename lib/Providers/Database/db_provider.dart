import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

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
  String _dateOfBirth = '';
  String _deviceToken = '';
  bool? _rememberUser = false;

  String get userId => _userId;
  String get userName => _userName;
  String get email => _email;
  String get contact => _contact;
  int get coin => _coin;
  String get firstName => _firstName;
  String get lastName => _lastName;
  String get imageURL => _imageURL;
  String get dateOfBirth => _dateOfBirth;
  bool? get rememberUser => _rememberUser;
  String get deviceToken => _deviceToken;

//save user data starts here

  void saveUserDeviceToken(String? deviceToken) async {
    SharedPreferences value = await _pref;

    value.setString('devicetoken', deviceToken!);
  }
  //.

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

  Future saveUserCoin(int? coin) async {
    SharedPreferences value = await _pref;

    value.setInt('coin', coin!);
  }

  //.
  void saveUserImage(String? imageURL) async {
    SharedPreferences value = await _pref;

    value.setString('imageURL', imageURL!);
  }

  //.
  void saveUserDateOfBirth(String dateOfBirth) async {
    SharedPreferences value = await _pref;

    value.setString('date_of_birth', dateOfBirth);
  }

  //.
  void saveUserRemembrance(bool? rememberUser) async {
    SharedPreferences value = await _pref;

    value.setBool('remember_user', rememberUser!);
  }
  //.

  Future<String> getDeviceToken() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('devicetoken')) {
      String data = value.getString('devicetoken')!;
      _deviceToken = data;
      notifyListeners();
      return data;
    } else {
      _deviceToken = '';
      notifyListeners();
      return '';
    }
  }

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

  Future<String> getDateOfBirth() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('date_of_birth')) {
      String data = value.getString('date_of_birth')!;
      _dateOfBirth = data;
      notifyListeners();
      return data;
    } else {
      _dateOfBirth = '';
      notifyListeners();
      return '';
    }
  }

  Future<bool> getUserRemembrance() async {
    SharedPreferences value = await _pref;

    if (value.containsKey('remember_user')) {
      bool data = value.getBool('remember_user')!;
      _rememberUser = data;
      notifyListeners();
      return data;
    } else {
      _rememberUser = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> clearDatabase(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
