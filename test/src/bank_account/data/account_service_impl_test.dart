import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_app/src/bank_account/data/account_service_impl.dart';
import 'package:top_up_app/src/bank_account/domain/transaction_state.dart';
import 'package:top_up_app/src/bank_account/domain/transaction_type.dart';

void main() {
  group('AccountServiceImpl', () {
    group('Deposit', () {
      test('Deposit with valid amount', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        const amount = 100;
        const type = TransactionType.deposit;

        // Act
        await accountService.makeTransaction(amount, type);

        // Assert
        expect(accountService.balance, 100);
        expect(
            accountService.lastTransactionState, isA<TransactionCompleted>());
      });

      test('Deposit with invalid amount', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        const amount = -100;
        const type = TransactionType.deposit;

        // Act
        await accountService.makeTransaction(amount, type);

        // Assert
        expect(accountService.balance, 0);

        final state = accountService.lastTransactionState;
        expect(state, isA<TransactionFailed>());

        final errorMessage = (state as TransactionFailed).errorMessage;
        expect(errorMessage, 'Invalid amount');
      });
    });

    group('Withdraw', () {
      test('Withdraw with valid amount', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        const amount = 100;
        const type = TransactionType.withdrawal;

        await accountService.makeTransaction(150, TransactionType.deposit);

        // Act
        await accountService.makeTransaction(amount, type);

        // Assert
        expect(accountService.balance, 50);

        final state = accountService.lastTransactionState;
        expect(state, isA<TransactionCompleted>());
      });

      test('Withdraw with invalid amount', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        const amount = -100;
        const type = TransactionType.withdrawal;

        // Act
        await accountService.makeTransaction(amount, type);

        // Assert
        final state = accountService.lastTransactionState;
        expect(state, isA<TransactionFailed>());

        final errorMessage = (state as TransactionFailed).errorMessage;
        expect(errorMessage, 'Invalid amount');
      });

      test('Withdraw with insufficient balance', () async {
        // Arrange
        final accountService = AccountServiceImpl();
        const amount = 100;
        const type = TransactionType.withdrawal;

        await accountService.makeTransaction(50, TransactionType.deposit);

        // Act
        await accountService.makeTransaction(amount, type);

        // Assert
        expect(accountService.balance, 50);
        expect(accountService.lastTransactionState, isA<TransactionFailed>());

        final state = accountService.lastTransactionState;
        expect(state, isA<TransactionFailed>());

        final errorMessage = (state as TransactionFailed).errorMessage;
        expect(errorMessage, 'Insufficient funds');
      });
    });
  });
}
