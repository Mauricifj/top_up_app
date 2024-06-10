import 'package:flutter/material.dart' hide BackButton;
import 'package:go_router/go_router.dart';

import '../../common/widgets/back_button.dart';
import '../domain/beneficiary.dart';
import 'top_ups_page.dart';

class DetailsBeneficiaryPage extends StatelessWidget {
  static const String path = 'details-beneficiary';
  static const String route = '${TopUpsPage.route}/$path';

  final Beneficiary beneficiary;

  const DetailsBeneficiaryPage({
    super.key,
    required this.beneficiary,
  });

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
                _buildNickname(context, beneficiary.nickname),
                const SizedBox(height: 16.0),
                _buildPhone(context, beneficiary.phone),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildEditButton(context, beneficiary),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      'Add Beneficiary',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildNickname(BuildContext context, String nickname) {
    return Text(
      nickname,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildPhone(BuildContext context, String phone) {
    return Text(
      phone,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }

  Widget _buildEditButton(BuildContext context, Beneficiary beneficiary) {
    return FloatingActionButton(
      onPressed: () => context.go('', extra: beneficiary),
      child: const Icon(Icons.edit),
    );
  }
}
