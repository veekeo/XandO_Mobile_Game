import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:xando/models/available_games_model.dart';
import 'package:xando/models/banks_code_model.dart';

class GetBanksCode extends ChangeNotifier {
  String _resMessage = '';
  bool _isLoading = false;
  bool _hasError = false;
  List<BanksCodeModel> _bankscode = [];

  bool get hasError => _hasError;
  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  List<BanksCodeModel> get availableGames => _bankscode;

  Future<List<BanksCodeModel>> getBanksCode() async {
    List<BanksCodeModel> bankscode = [];
    _isLoading = true;
    notifyListeners();

    String url = 'https://nigerianbanks.xyz/';

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        if (json.decode(req.body) == null) {
          return _bankscode;
        } else {
          final bankscodemodel = banksCodeModelFromJson(req.body);
          _bankscode = bankscodemodel;
          notifyListeners();
          return bankscodemodel;
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
    return bankscode;
  }
}
