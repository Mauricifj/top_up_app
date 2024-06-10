import 'package:flutter/material.dart' hide BackButton;
import 'package:go_router/go_router.dart';

import '../../common/widgets/back_button.dart';
import '../domain/beneficiary_service.dart';
import '../domain/top_up_service.dart';
import 'add_beneficiary_page.dart';
import 'widgets/beneficiary_options_widget.dart';
import 'widgets/top_up_history.dart';

class TopUpsPage extends StatelessWidget {
  static const String path = 'top-ups';
  static const String route = '/$path';

  final BeneficiaryService beneficiaryService;
  final TopUpService topUpService;

  const TopUpsPage({
    super.key,
    required this.beneficiaryService,
    required this.topUpService,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: BackButton(),
            ),
            const SizedBox(height: 24.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Mobile Recharge', style: TextStyle(fontSize: 24.0)),
            ),
            BeneficiaryOptionsWidget(beneficiaryService: beneficiaryService),
            const SizedBox(height: 16.0),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('History', style: TextStyle(fontSize: 24.0)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TopUpHistory(topUps: topUpService.topUps),
            ),
          ],
        ),
      ),
      floatingActionButton: beneficiaryService.beneficiaries.length < 5
          ? FloatingActionButton(
              onPressed: () => context.go(AddBeneficiaryPage.route),
              child: const Icon(Icons.person_add),
            )
          : null,
    );
  }
}
