import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../top_up/presentation/top_ups_page.dart';
import '../transaction_page.dart';
import 'account_service_button.dart';

class AccountServicesWidget extends StatelessWidget {
  const AccountServicesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          AccountServiceButton(
            title: 'Deposit',
            icon: Icons.add,
            onPressed: () {
              context.go(TransactionPage.depositRoute);
            },
          ),
          const SizedBox(width: 10),
          AccountServiceButton(
            title: 'Withdraw',
            icon: Icons.remove,
            onPressed: () {
              context.go(TransactionPage.withdrawRoute);
            },
          ),
          const SizedBox(width: 10),
          AccountServiceButton(
            title: 'Top Up',
            icon: Icons.mobile_friendly,
            onPressed: () {
              context.go(TopUpsPage.route);
            },
          ),
          const SizedBox(width: 10),
          AccountServiceButton(
            title: 'Transfer',
            icon: Icons.swap_horiz,
            onPressed: () {
              _showFeatureNotImplementedSnackBar(context);
            },
          ),
          const SizedBox(width: 10),
          AccountServiceButton(
            title: 'Invest',
            icon: Icons.attach_money,
            onPressed: () {
              _showFeatureNotImplementedSnackBar(context);
            },
          ),
          const SizedBox(width: 10),
          AccountServiceButton(
            title: 'Loan',
            icon: Icons.currency_exchange,
            onPressed: () {
              _showFeatureNotImplementedSnackBar(context);
            },
          ),
        ],
      ),
    );
  }

  void _showFeatureNotImplementedSnackBar(BuildContext context) {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    scaffoldMessenger.clearSnackBars();
    scaffoldMessenger.showSnackBar(
      const SnackBar(
        content: Text('Feature not implemented yet'),
      ),
    );
  }
}
