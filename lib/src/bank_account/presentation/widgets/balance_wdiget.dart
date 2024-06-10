import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/account_service.dart';

class BalanceWidget extends StatelessWidget {
  const BalanceWidget({
    super.key,
    required this.accountService,
  });

  final AccountService accountService;

  @override
  Widget build(BuildContext context) {
    final formatter = NumberFormat.currency(
      locale: 'ar',
      symbol: '\$',
      decimalDigits: 2,
    );

    return ListenableBuilder(
      listenable: accountService,
      builder: (context, _) {
        final formattedBalance = formatter.format(accountService.balance / 100);

        return Text(
          'Account Balance: $formattedBalance',
          style: const TextStyle(fontSize: 18),
        );
      },
    );
  }
}
