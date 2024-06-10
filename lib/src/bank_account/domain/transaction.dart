import 'transaction_type.dart';

class Transaction {
  final String id;
  final String description;
  final TransactionType type;
  final int amount;
  final DateTime date;
  final bool failed;

  Transaction({
    required this.id,
    required this.description,
    required this.type,
    required this.amount,
    required this.date,
    this.failed = false,
  });
}
