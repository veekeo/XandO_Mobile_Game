import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xando/models/available_games_model.dart';

class GetAvailableGamesProvider extends ChangeNotifier {
  String _resMessage = '';
  bool _isLoading = false;
  bool _hasError = false;
  List<AvailableGamesModel> _availableGames = [];

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  List<AvailableGamesModel> get availableGames => _availableGames;

  Future<List<AvailableGamesModel>> getAvailableGames() async {
    List<AvailableGamesModel> availableGames = [];
    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/create-game/';

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        if (json.decode(req.body) == null) {
          return availableGames;
        } else {
          final gamesModel = availableGamesModelFromJson(req.body);
          _availableGames = gamesModel;
          notifyListeners();
          return gamesModel;
        }
      } else {
        _isLoading = false;
        _hasError = true;
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
    return availableGames;
  }
}
