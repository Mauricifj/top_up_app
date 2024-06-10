import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/beneficiary.dart';
import '../../domain/top_up_service.dart';

class MaxTopUpPerBeneficiaryPerMonthWidget extends StatelessWidget {
  const MaxTopUpPerBeneficiaryPerMonthWidget({
    super.key,
    required this.topUpService,
    required this.beneficiary,
  });

  final Beneficiary beneficiary;
  final TopUpService topUpService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: topUpService.maxTopUpPerBeneficiaryPerMonth(beneficiary),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        final maxTopUpPerBeneficiaryPerMonth = snapshot.data as int;

        final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);

        final monthNameFormatter = DateFormat('MMMM');
        final currentMonth = monthNameFormatter.format(
          DateTime.now(),
        );

        return Text(
          'Top up amount left in $currentMonth to ${beneficiary.nickname}: ${currencyFormatter.format(maxTopUpPerBeneficiaryPerMonth / 100)}',
        );
      },
    );
  }
}
