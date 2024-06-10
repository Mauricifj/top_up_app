import 'package:flutter/material.dart';

import '../auth/domain/auth_service.dart';
import '../bank_account/domain/account_service.dart';
import '../bank_account/presentation/widgets/account_services_widget.dart';
import '../bank_account/presentation/widgets/balance_wdiget.dart';
import 'widgets/greeting_widget.dart';
import '../bank_account/presentation/widgets/transactions_widget.dart';

class HomePage extends StatelessWidget {
  static const String path = '/';

  final AuthService authService;
  final AccountService accountService;

  const HomePage({
    super.key,
    required this.authService,
    required this.accountService,
  });

  @override
  Widget build(BuildContext context) {
    final user = authService.user;

    final transactions = accountService.transactions;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GreetingWidget(user: user),
              const SizedBox(height: 32),
              BalanceWidget(accountService: accountService),
              const SizedBox(height: 32),
              const AccountServicesWidget(),
              const SizedBox(height: 32),
              TransactionsWidget(transactions: transactions),
            ],
          ),
        ),
      ),
    );
  }
}
