import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';

class CreateGameProvider extends ChangeNotifier {
  String _resMessage = '';
  bool _isLoading = false;
  bool _hasError = false;
  double _potentialWin = 0;
  int _idOfGame = 0;
  String _gameId = '';
  String _stake = '';
  String _username = '';
  bool _state = true;
  String _userId = '';
  String _userAvatar = '';
  String _userDeviceToken = '';

  bool get hasError => _hasError;
  bool get state => _state;
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  double get potentialWin => _potentialWin;
  String get gameId => _gameId;
  String get stake => _stake;
  String get username => _username;
  int get idOfGame => _idOfGame;
  String get userId => _userId;
  String get userAvatar => _userAvatar;
  String get userDeviceToken => _userDeviceToken;

  Future<void> createGame(
    BuildContext context,
    String? userId,
    String? gameTitle,
    String? stake,
  ) async {
    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/create-game/';

    final body = {
      'user': userId,
      'title': gameTitle,
      'stake': stake,
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        _idOfGame = res['id'];
        _state = res['state'];
        _gameId = res['game_id'];
        _stake = res['stake'];
        _username = res['user']['username'];
        _userId = res['user']['id'];
        _userAvatar = res['user']['avatar'];
        _userDeviceToken = res['user']['devicetoken'];
        _resMessage = 'Game created successfully';
        _hasError = false;
        _isLoading = false;
        notifyListeners();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Something went wrong, try again';
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

  //delete game
  Future<void> deleteGame(
    BuildContext context,
    String? userId,
    String? id,
  ) async {
    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/game/games/$userId?game=$id';

    try {
      http.Response req = await http.delete(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Something went wrong, try again';
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

  Future<void> calcUserWinBalance(
      BuildContext context, int initialAmount, int wonAmount) async {
    final userId = await DatabaseProvider().getUserId();
    // ignore: use_build_context_synchronously
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    int userTotalAmount = wonAmount + initialAmount;
    _isLoading = true;
    notifyListeners();

    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/coin/$userId/';

    final body = {
      "balance": userTotalAmount,
    };

    //.....
    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        dbProvider.saveUserCoin(res['balance']);

        _isLoading = false;
        _hasError = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Deposit Failed';
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

  Future<void> calcUserLostBalance(
      BuildContext context, double initialAmount, double lostAmount) async {
    final userId = await DatabaseProvider().getUserId();
    // ignore: use_build_context_synchronously
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    double userTotalAmount = lostAmount - initialAmount;
    _isLoading = true;
    notifyListeners();

    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/coin/$userId/';

    final body = {
      "balance": userTotalAmount,
    };

    //.....
    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        dbProvider.saveUserCoin(res['balance']);

        _isLoading = false;
        _hasError = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Deposit Failed';
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

  Future<void> calcBalanceAfterGameCreation(
      BuildContext context, double initialAmount, double stake) async {
    final userId = await DatabaseProvider().getUserId();
    // ignore: use_build_context_synchronously
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    double userTotalAmount = initialAmount - stake;
    _isLoading = true;
    notifyListeners();

    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/coin/$userId/';

    final body = {
      "balance": userTotalAmount,
    };

    //.....
    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        body: json.encode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200) {
        final res = json.decode(req.body);
        dbProvider.saveUserCoin(res['balance']);

        _isLoading = false;
        _hasError = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Deposit Failed';
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

  Future<double> calculateDiscount(double stake) async {
    // Calculate the sum of the two equal numbers
    double sum = 2 * stake;

    // Calculate 20% off the sum
    double discount = 0.15 * sum;

    // Calculate the final discounted value
    double discountedValue = sum - discount;

    _potentialWin = discountedValue;

    notifyListeners();
    return discountedValue;
  }
}
