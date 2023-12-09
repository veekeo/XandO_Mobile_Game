import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class CreateGameProvider extends ChangeNotifier {
  String _resMessage = '';
  bool _isLoading = false;
  bool _hasError = false;
  double _potentialWin = 0;

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  double get potentialWin => _potentialWin;

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
        print(res);
        // dbProvider.saveUsercontact(res['username']);
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

  void calculateDiscount(double stake) {
    // Calculate the sum of the two equal numbers
    double sum = 2 * stake;

    // Calculate 20% off the sum
    double discount = 0.20 * sum;

    // Calculate the final discounted value
    double discountedValue = sum - discount;

    _potentialWin = discountedValue;
    notifyListeners();
  }
}
