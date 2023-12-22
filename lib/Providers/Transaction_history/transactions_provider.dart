import 'package:flutter/material.dart';
import 'package:xando/models/transaction_history/withdrawals_history_model.dart';

class TransactionsProvider extends ChangeNotifier {
  List<WithdrawalsHistoryModel> withdrawalsHistoryList = [];

  addWithdrawalsHistory(WithdrawalsHistoryModel withdrawalsHistory) {
    withdrawalsHistoryList.add(withdrawalsHistory);
    notifyListeners();
  }
}
