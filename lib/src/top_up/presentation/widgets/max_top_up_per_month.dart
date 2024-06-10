
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/top_up_service.dart';

class MaxTopUpPerMonthWidget extends StatelessWidget {
  const MaxTopUpPerMonthWidget({
    super.key,
    required this.topUpService,
  });

  final TopUpService topUpService;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: topUpService.maxTopUpPerMonth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('Loading...');
        }

        final currencyFormatter = NumberFormat.simpleCurrency(decimalDigits: 2);

        final monthNameFormatter = DateFormat('MMMM');
        final currentMonth = monthNameFormatter.format(
          DateTime.now(),
        );

        final maxTopUpPerBeneficiaryPerMonth = snapshot.data as int;

        return Text(
          'Top up amount left in $currentMonth: ${currencyFormatter.format(maxTopUpPerBeneficiaryPerMonth / 100)}',
        );
      },
    );
  }
}


