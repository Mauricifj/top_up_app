import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_app/src/auth/data/auth_service_impl.dart';
import 'package:top_up_app/src/bank_account/data/account_service_impl.dart';
import 'package:top_up_app/src/bank_account/domain/transaction_type.dart';
import 'package:top_up_app/src/top_up/data/top_up_service_impl.dart';
import 'package:top_up_app/src/top_up/domain/beneficiary.dart';

void main() {
  group('TopUpServiceImpl', () {
    final beneficiary = Beneficiary(
      uid: '123',
      nickname: 'John Doe',
      phone: '081234567890',
    );

    group('TopUp', () {
      test('TopUp with valid amount', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        final authService = AuthServiceImpl();

        await accountService.makeTransaction(20000, TransactionType.deposit);

        final topUpService = TopUpServiceImpl(
          accountService: accountService,
          authService: authService,
        );

        // Act
        await topUpService.topUp(10000, beneficiary);

        // Assert
        expect(topUpService.topUps.length, 1);
        expect(topUpService.topUps.first.amount, 10000);
      });

      test('TopUp with invalid amount', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        final authService = AuthServiceImpl();

        await accountService.makeTransaction(5000, TransactionType.deposit);

        final topUpService = TopUpServiceImpl(
          accountService: accountService,
          authService: authService,
        );

        // Act
        await topUpService.topUp(10000, beneficiary);

        // Assert
        expect(topUpService.topUps.length, 0);
      });
    });

    // Future<int> maxTopUpPerBeneficiaryPerMonth(Beneficiary beneficiary);
    // Future<int> maxTopUpPerMonth();

    group('MaxTopUpPerBeneficiaryPerMonth', () {
      test('Not Verified User', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        final authService = AuthServiceImpl();

        await authService.login('email@email.com', 'password');
        await accountService.makeTransaction(20000, TransactionType.deposit);

        final topUpService = TopUpServiceImpl(
          accountService: accountService,
          authService: authService,
        );

        // Act
        final maxTopUpPerBeneficiaryPerMonth =
            await topUpService.maxTopUpPerBeneficiaryPerMonth(beneficiary);

        // Assert
        expect(maxTopUpPerBeneficiaryPerMonth, 50000);
      });

      test('Verified User', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        final authService = AuthServiceImpl();

        await authService.login('email@email.com', 'password');
        await authService.verifyEmail();
        await accountService.makeTransaction(20000, TransactionType.deposit);

        final topUpService = TopUpServiceImpl(
          accountService: accountService,
          authService: authService,
        );

        // Act
        final maxTopUpPerBeneficiaryPerMonth =
            await topUpService.maxTopUpPerBeneficiaryPerMonth(beneficiary);

        // Assert
        expect(maxTopUpPerBeneficiaryPerMonth, 100000);
      });

      test('MaxTopUpPerMonth', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        final authService = AuthServiceImpl();

        await authService.login('email@email.com', 'password');
        await accountService.makeTransaction(20000, TransactionType.deposit);

        final topUpService = TopUpServiceImpl(
          accountService: accountService,
          authService: authService,
        );

        // Act
        final maxTopUpPerBeneficiaryPerMonth =
            await topUpService.maxTopUpPerMonth();

        // Assert
        expect(maxTopUpPerBeneficiaryPerMonth, 300000);
      });
    });
  });
}
