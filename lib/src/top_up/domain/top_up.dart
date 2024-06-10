import 'beneficiary.dart';

class TopUp {
  final Beneficiary beneficiary;
  final int amount;
  final DateTime date;


  TopUp({
    required this.beneficiary,
    required this.amount,
    required this.date,
  });
}
