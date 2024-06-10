import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../domain/beneficiary_service.dart';
import '../add_beneficiary_page.dart';
import '../edit_beneficiary_page.dart';
import '../top_up_page.dart';

class BeneficiaryOptionsWidget extends StatelessWidget {
  const BeneficiaryOptionsWidget({
    super.key,
    required this.beneficiaryService,
  });

  final BeneficiaryService beneficiaryService;

  @override
  Widget build(BuildContext context) {
    if (beneficiaryService.beneficiaries.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('No beneficiaries found'),
            const SizedBox(width: 10),
            ElevatedButton(
              onPressed: () {
                context.go(AddBeneficiaryPage.route);
              },
              child: const Text('Add Beneficiary'),
            ),
          ],
        ),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    const margin = 16.0;
    final availableWidth = width - (width * 0.2) - (margin * 3);

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colorScheme = theme.colorScheme;

    return SizedBox(
      height: 180,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          final beneficiary = beneficiaryService.beneficiaries[index];

          return LayoutBuilder(builder: (context, constraints) {
            return Container(
              width: availableWidth / 2,
              margin: const EdgeInsets.only(left: margin),
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 8.0,
              ),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                border: Border.all(color: colorScheme.onPrimaryContainer),
                borderRadius: BorderRadius.circular(10),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  context.go(EditBeneficiaryPage.route, extra: beneficiary);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      beneficiary.nickname,
                      maxLines: 3,
                      overflow: TextOverflow.fade,
                      style: textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      beneficiary.phone,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const SizedBox(height: 5),
                    ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 250,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          context.go(TopUpPage.route, extra: beneficiary);
                        },
                        child: const FittedBox(child: Text('Recharge now')),
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
        itemCount: beneficiaryService.beneficiaries.length,
      ),
    );
  }
}
