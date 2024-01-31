import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:xando/Providers/Database/db_provider.dart';

class PaystackProvider extends ChangeNotifier {
  bool _isLoading = false;
  String _resMessage = '';
  bool _hasError = false;
  String _reference = '';
  int _depositedAmount = 0;
  // int _userInputAmount = 0;

  String _authorizationUrl = '';

  bool get isLoading => _isLoading;
  String get resMessage => _resMessage;
  bool get hasError => _hasError;
  String get authorizationUrl => _authorizationUrl;
  String get reference => _reference;

  int get stake => _depositedAmount;

  //<-------------------Transfer Variables-------------------->
  int _transferAmount = 0;
  String _recipientCode = '';
  bool _transferStatus = false;

  int get transferAmount => _transferAmount;
  String get recipientCode => _recipientCode;
  bool get transferStatus => _transferStatus;

  String apiKey = 'sk_live_c0b3015a647d231ca553ed1d5ea2d417560e420c';

  Future getPaystackCheckoutUrl(String email, String amount) async {
    _isLoading = true;
    notifyListeners();

    String url = 'https://api.paystack.co/transaction/initialize';

    final int stake = int.parse(amount) * 100;
    // _userInputAmount = int.parse(amount);
    notifyListeners();

    final body = {
      "email": email,
      "amount": stake,
      "metadata": {"cancel_action": "https://google.com"}
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        _authorizationUrl = res['data']['authorization_url'];
        _reference = res['data']['reference'];
        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
        _isLoading = false;
        _hasError = true;
        _resMessage = 'Something went wrong, try again.';
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

  //Verify Transaction
  Future verifyTransaction(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    String url = 'https://api.paystack.co/transaction/verify/$reference';
    String apiKey = 'sk_live_c0b3015a647d231ca553ed1d5ea2d417560e420c';

    try {
      http.Response req = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        _depositedAmount = res['data']['amount'];
        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
        final res = json.decode(req.body);
        _isLoading = false;
        _resMessage = res['message'];
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
  }

//Calculate User Balance
  Future<void> calcUserTotalAmount(
      BuildContext context, int initialAmount, int userInputAmount) async {
    final userId = await DatabaseProvider().getUserId();
    // ignore: use_build_context_synchronously
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    int userTotalAmount = userInputAmount + initialAmount;
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

  //<---------------Transfers--------------------->

  //Create Transfer Recepient

  Future createTransferRecipient(String accountNumber, String bankCode) async {
    _isLoading = true;
    notifyListeners();

    String url = 'https://api.paystack.co/transferrecipient';

    final body = {
      "type": "nuban",
      "account_number": accountNumber,
      "bank_code": bankCode,
      "currency": "NGN"
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        _recipientCode = res['data']['recipient_code'];
        _transferStatus = true;
        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else {
        final res = json.decode(req.body);

        _isLoading = false;
        _hasError = true;
        _transferStatus = false;
        _resMessage = res['message'];
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

  //Initiate Transfer
  Future initiateTransfer(String amount) async {
    int tAmount = int.parse(amount) * 100;
    _transferAmount = int.parse(amount);
    _isLoading = true;
    notifyListeners();

    String url = 'https://api.paystack.co/transfer';

    final body = {
      "amount": tAmount,
      "recipient": _recipientCode,
    };

    try {
      http.Response req = await http.post(
        Uri.parse(url),
        body: json.encode(body),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
      );

      if (req.statusCode == 200 || req.statusCode == 201) {
        final res = json.decode(req.body);

        _resMessage = res['message'];
        _transferStatus = res['status'];
        _hasError = false;
        _isLoading = false;
        notifyListeners();
      } else if (req.statusCode == 400) {
        final res = json.decode(req.body);

        _resMessage = res['message'];
        _transferStatus = res['status'];
        _isLoading = false;
        notifyListeners();
      } else {
        final res = json.decode(req.body);
        _transferStatus = true;
        _isLoading = false;
        _hasError = true;
        _resMessage = res['message'];
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

  //Calculate User Balance aftrer Transfer
  Future<void> calcUserTotalAmountAfterTransfer(
      BuildContext context, int initialAmount) async {
    final userId = await DatabaseProvider().getUserId();
    // ignore: use_build_context_synchronously
    final dbProvider = Provider.of<DatabaseProvider>(context, listen: false);
    int userTotalAmount = initialAmount - _transferAmount;
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
}
