import 'package:flutter/material.dart';

import '../domain/beneficiary.dart';
import '../domain/beneficiary_service.dart';
import '../domain/beneficiary_state.dart';

class BeneficiaryServiceImpl extends ChangeNotifier
    implements BeneficiaryService {
  final List<Beneficiary> _beneficiaries = [];
  BeneficiaryState _lastBeneficiaryState = BeneficiaryState.initial;

  @override
  List<Beneficiary> get beneficiaries => _beneficiaries;

  @override
  BeneficiaryState get lastBeneficiaryState => _lastBeneficiaryState;

  @override
  Future<void> addBeneficiary(Beneficiary beneficiary) async {
    _lastBeneficiaryState = BeneficiaryState.loading;
    notifyListeners();

    if (_beneficiaries.length >= 5) {
      _lastBeneficiaryState = BeneficiaryState.limitReached;
      notifyListeners();
      return;
    }

    if (!_isValid(beneficiary)) {
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    _beneficiaries.add(beneficiary);
    _lastBeneficiaryState = BeneficiaryState.success;

    notifyListeners();
  }

  @override
  @override
  Future<void> removeBeneficiary(Beneficiary beneficiary) async {
    _lastBeneficiaryState = BeneficiaryState.loading;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    _beneficiaries.remove(beneficiary);
    _lastBeneficiaryState = BeneficiaryState.success;
    notifyListeners();
  }

  @override
  Future<void> updateBeneficiary(
    Beneficiary beneficiary,
    String? nickname,
    String? phone,
  ) async {
    _lastBeneficiaryState = BeneficiaryState.loading;
    notifyListeners();

    if (nickname != beneficiary.nickname && !_nicknameIsValid(nickname)) {
      return;
    }

    if (phone != beneficiary.phone && !_phoneIsValid(phone)) {
      return;
    }

    await Future.delayed(const Duration(seconds: 1));

    final index = _beneficiaries.indexOf(beneficiary);

    if (index == -1) {
      _lastBeneficiaryState = BeneficiaryState.notFound;
      notifyListeners();
      return;
    }

    _beneficiaries[index] = beneficiary.copyWith(
      nickname: nickname,
      phone: phone,
    );
    _lastBeneficiaryState = BeneficiaryState.success;
    notifyListeners();
  }

  bool _isValid(Beneficiary beneficiary) {
    return _nicknameIsValid(beneficiary.nickname) &&
        _phoneIsValid(beneficiary.phone);
  }

  bool _nicknameIsValid(String? nickname) {
    final found = _beneficiaries.any((b) => b.nickname == nickname);

    if (found) {
      _lastBeneficiaryState = BeneficiaryState.duplicateNickname;
      notifyListeners();
      return false;
    }

    return true;
  }

  bool _phoneIsValid(String? phone) {
    final found = _beneficiaries.any((b) => b.phone == phone);

    if (found) {
      _lastBeneficiaryState = BeneficiaryState.duplicatePhone;
      notifyListeners();
      return false;
    }

    return true;
  }
}
