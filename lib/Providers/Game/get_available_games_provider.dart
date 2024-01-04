import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xando/models/available_games_model.dart';

class GetAvailableGamesProvider extends ChangeNotifier {
  // CollectionReference userRequests =
  //     FirebaseFirestore.instance.collection('userRequests');

  // CollectionReference pendingRequests =
  //     FirebaseFirestore.instance.collection('pendingRequests');

  //--------------------------------
  String _resMessage = '';
  bool _isLoading = false;
  bool _hasError = false;
  List<AvailableGamesModel> _availableGames = [];
  List<AvailableGamesModel> _searchedGames = [];
  bool _alreadyRequested = false;

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  List<AvailableGamesModel> get availableGames => _availableGames;
  List<AvailableGamesModel> get searchedGames => _searchedGames;
  bool get aleadyRequested => _alreadyRequested;

  Future<List<AvailableGamesModel>> searchGamesByQuery(String query) async {
    _isLoading = true;
    notifyListeners();

    print('Before Search: IsLoading=$_isLoading');

    List<AvailableGamesModel> searchResults = _availableGames
        .where(
          (game) =>
              game.gameId!.toLowerCase().contains(query.toLowerCase()) ||
              game.title!.toLowerCase().contains(query.toLowerCase()) ||
              game.user!.username!.toLowerCase().contains(query.toLowerCase()),
        )
        .toList();

    _searchedGames = searchResults;
    _isLoading = false;
    notifyListeners();
    print('After Search: IsLoading=$_isLoading');

    return searchResults;
  }

//Get available
  Future<List<AvailableGamesModel>> getAvailableGames() async {
    List<AvailableGamesModel> availableGames = [];
    // _isLoading = true;
    // notifyListeners();
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

  //Update game state
  Future<void> updateGameState(bool state, String? id) async {
    _isLoading = true;
    notifyListeners();
    String requestbaseUrl = 'https://tictac-production.up.railway.app';
    String url = '$requestbaseUrl/tictac/create-game/$id/';

    final body = {
      "state": state,
    };

    try {
      http.Response req = await http.patch(
        Uri.parse(url),
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);
        print('Updated game state!!!');
        _isLoading = true;
        notifyListeners();
      } else {
        final res = json.decode(req.body);
        print(res);
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
      print(e.toString());
      notifyListeners();
    }
  }

  void switchAleadyRequested() {
    _alreadyRequested = true;
    notifyListeners();
  }
}
