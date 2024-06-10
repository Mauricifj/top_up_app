import 'package:flutter/material.dart';

import '../../auth/domain/auth_service.dart';
import '../../bank_account/domain/account_service.dart';
import '../../bank_account/domain/transaction_state.dart';
import '../../bank_account/domain/transaction_type.dart';
import '../domain/beneficiary.dart';
import '../domain/top_up.dart';
import '../domain/top_up_service.dart';
import '../domain/top_up_state.dart';

class TopUpServiceImpl extends ChangeNotifier implements TopUpService {
  final AccountService accountService;
  final AuthService authService;

  final verifiedEmailAmount = 100000;
  final notVerifiedEmailAmount = 50000;
  final maxTopUpPerMonthForAllBeneficiaries = 300000;


  TopUpServiceImpl({
    required this.accountService,
    required this.authService,
  });

  @override
  int get fee => 100;

  final List<TopUp> _topUps = [];

  @override
  List<TopUp> get topUps => _topUps;

  TopUpState _topUpState = TopUpState.initial;

  @override
  TopUpState get lastTopUpState => _topUpState;

  @override
  Future<List<int>> getTopUpOptions() async {
    return const [500, 1000, 2000, 3000, 5000, 7500, 10000];
  }

  @override
  Future<void> topUp(int amount, Beneficiary beneficiary) async {
    _topUpState = TopUpState.loading;
    notifyListeners();

    await accountService.makeTransaction(
      amount + fee,
      TransactionType.withdrawal,
      description: 'Top up to ${beneficiary.nickname}',
    );

    final state = accountService.lastTransactionState;
    if (state is TransactionFailed) {
      _topUpState = TopUpState.error;
      notifyListeners();
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    _topUps.add(
      TopUp(
        amount: amount,
        beneficiary: beneficiary,
        date: DateTime.now(),
      ),
    );
    _topUpState = TopUpState.success;
    notifyListeners();
  }

  @override
  Future<int> maxTopUpPerBeneficiaryPerMonth(Beneficiary beneficiary) async {
    final month = DateTime.now().month;
    final beneficiaryTopUpsOfCurrentMonth = topUps
        .where((topUp) => topUp.beneficiary.uid == beneficiary.uid)
        .where((topUp) => topUp.date.month == month)
        .toList();

    final total = beneficiaryTopUpsOfCurrentMonth.fold(
      0,
      (total, topUp) => total + topUp.amount,
    );

    final max = authService.user?.isVerified == true
        ? verifiedEmailAmount
        : notVerifiedEmailAmount;

    return max - total;
  }

  @override
  Future<int> maxTopUpPerMonth() async {
    final month = DateTime.now().month;
    final beneficiaryTopUpsOfCurrentMonth = topUps
        .where((topUp) => topUp.date.month == month)
        .toList();

    final total = beneficiaryTopUpsOfCurrentMonth.fold(
      0,
      (total, topUp) => total + topUp.amount,
    );

    return maxTopUpPerMonthForAllBeneficiaries - total;
  }


}
