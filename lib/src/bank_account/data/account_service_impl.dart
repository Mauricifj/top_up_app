import 'package:flutter/material.dart';

import '../domain/account_service.dart';
import '../domain/transaction.dart';
import '../domain/transaction_state.dart';
import '../domain/transaction_type.dart';

class AccountServiceImpl extends ChangeNotifier implements AccountService {
  int _balance = 0;
  TransactionState _transactionState = const TransactionInitialState();

  @override
  int get balance => _balance;

  @override
  TransactionState get lastTransactionState => _transactionState;

  @override
  Future<void> makeTransaction(
    int amount,
    TransactionType type, {
    String? description,
  }) async {
    switch (type) {
      case TransactionType.deposit:
        await _deposit(amount, description: description);
        break;
      case TransactionType.withdrawal:
        await _withdraw(amount, description: description);
        break;
    }
  }

  Future<void> _deposit(int amount, {String? description}) async {
    _transactionState = const TransactionInProgress();
    notifyListeners();

    if (!_isValidAmount(amount)) {
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    _balance += amount;
    _addTransaction(amount, TransactionType.deposit, description: description);

    _transactionState = const TransactionCompleted();
    notifyListeners();
  }

  Future<void> _withdraw(int amount, {String? description}) async {
    _transactionState = const TransactionInProgress();
    notifyListeners();

    if (!_isValidAmount(amount)) {
      return;
    }

    if (amount > balance) {
      _transactionState = const TransactionFailed('Insufficient funds');

      _addTransaction(
        amount,
        TransactionType.withdrawal,
        description: description,
        failed: true,
      );

      notifyListeners();
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    _balance -= amount;
    _addTransaction(
      amount,
      TransactionType.withdrawal,
      description: description,
    );

    _transactionState = const TransactionCompleted();
    notifyListeners();
  }

  bool _isValidAmount(int amount) {
    final isValid = amount > 0;
    if (!isValid) {
      _transactionState = const TransactionFailed('Invalid amount');
      notifyListeners();
    }
    return isValid;
  }

  final List<Transaction> _transactions = [];

  void _addTransaction(
    int amount,
    TransactionType type, {
    String? description,
    bool failed = false,
  }) {
    final now = DateTime.now();
    _transactions.add(
      Transaction(
        id: now.microsecondsSinceEpoch.toString(),
        description: description ?? type.displayName,
        amount: amount,
        date: DateTime.now(),
        type: type,
        failed: failed,
      ),
    );
    notifyListeners();
  }

  @override
  List<Transaction> get transactions => _transactions;
}
