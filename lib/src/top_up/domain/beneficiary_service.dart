import 'package:flutter/material.dart';

import 'beneficiary.dart';
import 'beneficiary_state.dart';

abstract interface class BeneficiaryService extends ChangeNotifier {
  List<Beneficiary> get beneficiaries;
  BeneficiaryState get lastBeneficiaryState;
  Future<void> addBeneficiary(Beneficiary beneficiary);
  Future<void> removeBeneficiary(Beneficiary beneficiary);
  Future<void> updateBeneficiary(
    Beneficiary beneficiary,
    String? nickname,
    String? phone,
  );
}
