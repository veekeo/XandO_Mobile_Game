import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';
import 'package:xando/screens/Auth_Screens/add_phone_number_screen.dart';

class GoogleAuthenticationProvider extends ChangeNotifier {
//instance of Firebase Auth and google
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final String userPassword = 'user@xando.game';

  bool _isLoading = false;
  String _resMessage = '';

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;

  bool _hasError = false;
  bool get hasError => _hasError;

  String? _errorCode;
  String? get errorCode => _errorCode;

  String? _provider;
  String? get provider => _provider;

  String? _uid;
  String? get uid => _uid;

  String? _email;
  String? get email => _email;

  String? _imageURL;
  String? get imageURL => _imageURL;

  String? _name;
  String? get name => _name;

  // sign in with google
  Future signInWithGoogle(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        //sign in to firebase user instace

        final User userDetails =
            (await firebaseAuth.signInWithCredential(credential)).user!;

        //save all th values gotten from the users details

        _name = userDetails.displayName;
        _email = userDetails.email;
        print('Emailllll 000 $_email');
        _uid = userDetails.uid;
        _imageURL = userDetails.photoURL;
        _provider = 'GOOGLE';
        _isLoading = false;
        notifyListeners();

        // ignore: use_build_context_synchronously
        await isUserSignedUp(context).then((value) async {
          if (value == true) {
            await signInUserWithData(context).then((value) =>
                Navigator.of(context)
                    .pushReplacement(CupertinoPageRoute(builder: (_) {
                  return const AddPhoneNumberScreen();
                })));
          } else {
            await saveUserData(context, _email).then((value) =>
                signInUserWithData(context).then((value) =>
                    Navigator.of(context)
                        .pushReplacement(CupertinoPageRoute(builder: (_) {
                      return const AddPhoneNumberScreen();
                    }))));
          }
        });
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "account-exists-with-different-credential":
            _errorCode =
                "You already have an account with us. Use correct provider";
            _hasError = true;
            notifyListeners();

            break;
          case "sign_in_canceled":
            _errorCode = "Google Authentication cancelled";
            _hasError = true;
            notifyListeners();

            break;
          case "null":
            _errorCode = "Some unexpected error while trying to sign in";
            _hasError = true;
            notifyListeners();
            break;
          default:
            _errorCode = e.toString();
            _hasError = true;
            _isLoading = false;
            notifyListeners();
        }
      }
    } else {
      _isLoading = false;
      _hasError = true;
      notifyListeners();
      return null;
    }
  }

  //check for user in DB
  Future<bool> isUserSignedUp(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    String userId = await DatabaseProvider().getUserId();
    const String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/$userId/';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final user = json.decode(response.body);
        print(user);
        print('i have checked user: $user');
        _isLoading = false;
        notifyListeners();
        // User is signed up
        return true;
      } else if (response.statusCode == 404) {
        _isLoading = false;
        notifyListeners();
        // User is not signed up
        return false;
      } else {
        _isLoading = false;
        notifyListeners();
        // Handle other status codes if needed
        print(
            'Failed to check user signup status. Status code: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      // Handle network or other errors
      print('Error checking user signup status: $e');
      return false;
    }
  }

  //Get User Data from DB if user exists
  Future signInUserWithData(BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    // ignore: use_build_context_synchronously
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    const String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/gamer/sign-in';
    print('i have checked user with email: $_email');

    final body = {
      "email": _email,
      "password": userPassword,
    };

    try {
      http.Response req =
          await http.post(Uri.parse(url), body: json.encode(body), headers: {
        'Content-Type': 'application/json',
      });

      if (req.statusCode == 200) {
        final data = json.decode(req.body);
        print('yes we are here: $data');
        _isLoading = false;
        notifyListeners();
        //saving to shared pref.
        dbProvider.saveUsername(data['user_data']['username']);
        dbProvider.saveUserId(data['user_data']['id']);
        dbProvider.saveUseremail(data['user_data']['email']);
        dbProvider.saveUserFirstName(data['user_data']['first_name']);
        dbProvider.saveUserlastName(data['user_data']['last_name']);
        dbProvider.saveUserDateOfBirth(data['user_data']['date_of_birth']);
        dbProvider.saveUserCoin(data['user_data']['coin']);
        print(data);
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
        _hasError = true;
        notifyListeners();
      }
    } on SocketException catch (_) {
      _isLoading = false;
      _resMessage = 'Internet Connection is not available';
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _resMessage = e.toString();
      notifyListeners();
    }
  }

  //Register User if user doenst exists in the DB
  Future saveUserData(BuildContext context, String? userEmail) async {
    _isLoading = true;
    notifyListeners();
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);

    const String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/sign-up/';
    final body = {
      "email": userEmail,
      "password": userPassword,
    };

    try {
      http.Response req = await http.post(Uri.parse(url),
          body: json.encode(body),
          headers: {'Content-Type': 'application/json'});

      if (req.statusCode == 200 || req.statusCode == 201) {
        _isLoading = false;
        notifyListeners();
        final res = json.decode(req.body);
        print(res);
        dbProvider.saveUsername(res['username']);
        dbProvider.saveUserId(res['id']);
        dbProvider.saveUseremail(res['email']);
        dbProvider.saveUserFirstName(res['first_name']);
        dbProvider.saveUserlastName(res['last_name']);
        dbProvider.saveUserDateOfBirth(res['date_of_birth']);
        // dbProvider.saveUserCoin(res['coin']);

        print('saved user data');
        notifyListeners();
        _isLoading = false;
        _resMessage = 'Account created';
        notifyListeners();
      } else {
        _isLoading = false;
        notifyListeners();
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
      _resMessage = e.toString();
      notifyListeners();
    }

    notifyListeners();
  }

  //Sign out
  Future signOut() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
    _hasError = false;
    notifyListeners();

    //clear all storage data on local db
  }
}
