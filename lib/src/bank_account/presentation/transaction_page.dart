import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart' hide BackButton;
import 'package:go_router/go_router.dart';

import '../../common/widgets/back_button.dart';
import '../../common/widgets/loading.dart';
import '../domain/account_service.dart';
import '../domain/transaction_state.dart';
import '../domain/transaction_type.dart';

class TransactionPage extends StatefulWidget {
  static const String depositPath = 'deposit';
  static const String withdrawPath = 'withdraw';

  static const String depositRoute = '/$depositPath';
  static const String withdrawRoute = '/$withdrawPath';

  final AccountService accountService;
  final TransactionType transactionType;

  const TransactionPage({
    super.key,
    required this.accountService,
    required this.transactionType,
  });

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final formatter = CurrencyTextInputFormatter.currency(
    symbol: '\$',
    enableNegative: false,
    decimalDigits: 2,
    maxValue: 1000000,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BackButton(),
                const SizedBox(height: 56.0),
                _buildTitle(context),
                const SizedBox(height: 16.0),
                _buildAmountInput(),
                const SizedBox(height: 16.0),
                _buildAmountInputNote(context),
                const SizedBox(height: 32.0),
                _buildCurrentBalance(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildConfirmButton(),
    );
  }

  Widget _buildConfirmButton() {
    return ListenableBuilder(
      listenable: widget.accountService,
      builder: (context, _) {
        final state = widget.accountService.lastTransactionState;
        final isLoading = state is TransactionInProgress;

        return FloatingActionButton(
          onPressed: isLoading
              ? null
              : () async {
                  final amount = formatter.getUnformattedValue() as double;
                  final convertedAmount = (amount * 100).toInt();

                  await widget.accountService.makeTransaction(
                    convertedAmount,
                    widget.transactionType,
                  );

                  final state = widget.accountService.lastTransactionState;
                  switch (state) {
                    case TransactionCompleted():
                      if (context.mounted) {
                        context.pop();
                      }
                      break;
                    case TransactionFailed():
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.errorMessage)),
                        );
                      }
                      break;
                  }
                },
          child: isLoading ? const Loading() : const Icon(Icons.chevron_right),
        );
      },
    );
  }

  Text _buildCurrentBalance(BuildContext context) {
    return Text(
      'Current balance: \$${widget.accountService.balance}',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Text _buildAmountInputNote(BuildContext context) {
    return Text(
      'Amounts between \$1 and \$1,000,000 are accepted.',
      style: Theme.of(context).textTheme.labelSmall,
    );
  }

  TextFormField _buildAmountInput() {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Amount',
      ),
      inputFormatters: [formatter],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter an amount';
        }

        final amount = formatter.getUnformattedValue() as double;
        if (amount <= 0) {
          return 'Please enter a valid amount';
        }

        if (amount < 1 || amount > 1000000) {
          return 'Amounts between \$1 and \$1,000,000 are accepted.';
        }

        return null;
      },
      keyboardType: TextInputType.number,
    );
  }

  Text _buildTitle(BuildContext context) {
    return Text(
      'How much do you want to ${widget.transactionType.name}?',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }
}
