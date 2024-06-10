import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../domain/top_up.dart';

class TopUpHistory extends StatelessWidget {
  final List<TopUp> topUps;

  const TopUpHistory({
    super.key,
    required this.topUps,
  });

  @override
  Widget build(BuildContext context) {
    if (topUps.isEmpty) {
      return const Text(
        'No top-up history found.\nAdd a beneficiary to get started.',
      );
    }

    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    final dateFormatter = DateFormat('dd/MM/yyyy - HH:mm');

    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final topUp = topUps[index];
          final formattedDate = dateFormatter.format(topUp.date);

          return ListTile(
            title: Text(
              '${topUp.beneficiary.nickname} - ${topUp.beneficiary.phone}',
            ),
            subtitle: Text(formattedDate),
            trailing: Text(currencyFormatter.format(topUp.amount / 100)),
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: topUps.length,
      ),
    );
  }
}
