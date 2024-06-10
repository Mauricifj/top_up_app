import 'package:flutter/material.dart';

import 'transaction.dart';
import 'transaction_state.dart';
import 'transaction_type.dart';

abstract interface class AccountService extends ChangeNotifier {
  int get balance;
  List<Transaction> get transactions;
  TransactionState get lastTransactionState;
  Future<void> makeTransaction(
    int amount,
    TransactionType type, {
    String? description,
  });
}
