import 'package:flutter/material.dart';

import 'beneficiary.dart';
import 'top_up.dart';
import 'top_up_state.dart';

abstract interface class TopUpService extends ChangeNotifier {
  int get fee;
  List<TopUp> get topUps;
  TopUpState get lastTopUpState;
  Future<void> topUp(int amount, Beneficiary beneficiary);
  Future<List<int>> getTopUpOptions();
  Future<int> maxTopUpPerBeneficiaryPerMonth(Beneficiary beneficiary);
  Future<int> maxTopUpPerMonth();
}
