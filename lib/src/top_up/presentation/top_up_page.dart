import 'package:flutter/material.dart' hide BackButton;
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../bank_account/domain/account_service.dart';
import '../../common/widgets/back_button.dart';
import '../../common/widgets/loading.dart';
import '../domain/beneficiary.dart';
import '../domain/top_up_service.dart';
import '../domain/top_up_state.dart';
import 'top_ups_page.dart';
import 'widgets/max_top_up_per_beneficiary_per_month.dart';
import 'widgets/max_top_up_per_month.dart';
import 'widgets/top_up_options_list.dart';

class TopUpPage extends StatefulWidget {
  static const String path = 'top-up';
  static const String route = '${TopUpsPage.route}/$path';

  final Beneficiary beneficiary;

  final TopUpService topUpService;
  final AccountService accountService;

  const TopUpPage({
    super.key,
    required this.beneficiary,
    required this.topUpService,
    required this.accountService,
  });

  @override
  State<TopUpPage> createState() => _TopUpPageState();
}

class _TopUpPageState extends State<TopUpPage> {
  int selectedOption = 0;
  final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackButton(),
              const SizedBox(height: 16.0),
              Text(
                'How much would you like to top up ${widget.beneficiary.nickname}\'s phone number?',
                style: const TextStyle(fontSize: 20.0),
              ),
              const SizedBox(height: 16.0),
              FutureBuilder(
                future: widget.topUpService.getTopUpOptions(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Loading();
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return Text('Error: ${snapshot.error}');
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No top up options available');
                  }

                  final topUpOptions = snapshot.data ?? [];

                  return ListenableBuilder(
                    listenable: widget.topUpService,
                    builder: (context, _) {
                      final isLoading = widget.topUpService.lastTopUpState ==
                          TopUpState.loading;

                      final topUpService = widget.topUpService;
                      final accountService = widget.accountService;

                      final beneficiary = widget.beneficiary;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TopUpOptionsList(
                            topUpOptions: topUpOptions,
                            selectedOption: selectedOption,
                            isLoading: isLoading,
                            onChanged: (option) {
                              setState(() {
                                selectedOption = option ?? 0;
                              });
                            },
                          ),
                          const SizedBox(height: 16.0),
                          if (selectedOption != 0) ...[
                            _buildFinalBalance(accountService, topUpService),
                            _buildFeeIndicator(topUpService),
                            const SizedBox(height: 16.0),
                            MaxTopUpPerMonthWidget(
                              topUpService: topUpService,
                            ),
                            const SizedBox(height: 16.0),
                            MaxTopUpPerBeneficiaryPerMonthWidget(
                              topUpService: topUpService,
                              beneficiary: beneficiary,
                            ),
                            if (widget.accountService.balance <
                                selectedOption + topUpService.fee) ...[
                              const SizedBox(height: 16.0),
                              const Text(
                                'Insufficient funds',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ],
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ListenableBuilder(
        listenable: widget.topUpService,
        builder: (context, _) {
          final isLoading =
              widget.topUpService.lastTopUpState == TopUpState.loading;

          if (isLoading) {
            return const FloatingActionButton(
              onPressed: null,
              child: Loading(),
            );
          }

          return FloatingActionButton(
            onPressed: () async {
              await widget.topUpService.topUp(
                selectedOption,
                widget.beneficiary,
              );

              final state = widget.topUpService.lastTopUpState;

              if (state == TopUpState.success && context.mounted) {
                context.pop();
                return;
              }

              if (state == TopUpState.error && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Failed to top up. Try again later.'),
                  ),
                );
              }
            },
            child: const Icon(Icons.chevron_right),
          );
        },
      ),
    );
  }

  Text _buildFeeIndicator(TopUpService topUpService) {
    final fee = currencyFormatter.format(topUpService.fee / 100);

    return Text(
      'Fee: AED $fee',
    );
  }

  Text _buildFinalBalance(
      AccountService accountService, TopUpService topUpService) {
    final balanceInCents =
        (accountService.balance - selectedOption - topUpService.fee) / 100;

    final finalBalance = currencyFormatter.format(
      balanceInCents,
    );
    return Text(
      'Balance after top up: AED $finalBalance',
    );
  }
}
