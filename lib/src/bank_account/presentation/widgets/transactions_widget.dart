import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/transaction.dart';
import '../../domain/transaction_type.dart';

class TransactionsWidget extends StatelessWidget {
  const TransactionsWidget({
    super.key,
    required this.transactions,
  });

  final List<Transaction> transactions;

  @override
  Widget build(BuildContext context) {
    if (transactions.isEmpty) {
      return const Center(child: Text('No transactions yet'));
    }

    final formatter = NumberFormat.simpleCurrency(decimalDigits: 2);

    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        final transaction = transactions[index];

        return ListTile(
          leading: transaction.type == TransactionType.deposit
              ? const Icon(
                  Icons.arrow_upward,
                  color: Colors.green,
                )
              : const Icon(
                  Icons.arrow_downward,
                  color: Colors.red,
                ),
          title: Text(
            transaction.description,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              decoration:
                  transaction.failed ? TextDecoration.lineThrough : null,
            ),
          ),
          subtitle: Text(
            'Amount: ${formatter.format(transactions[index].amount / 100)}',
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat.yMMMd().format(transaction.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                DateFormat.Hm().format(transaction.date),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: transactions.length,
    );
  }
}
