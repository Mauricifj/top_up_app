import 'package:flutter_test/flutter_test.dart';
import 'package:top_up_app/src/top_up/data/beneficiary_service_impl.dart';
import 'package:top_up_app/src/top_up/domain/beneficiary.dart';
import 'package:top_up_app/src/top_up/domain/beneficiary_state.dart';

void main() {
  group('BeneficiaryServiceImpl', () {
    group('Add Beneficiary', () {
      test('Add beneficiary', () async {
        // Arrange
        final beneficiary = Beneficiary(
          uid: '123',
          nickname: 'John Doe',
          phone: '081234567890',
        );
        final beneficiaryService = BeneficiaryServiceImpl();

        // Act
        await  beneficiaryService.addBeneficiary(beneficiary);

        // Assert
        final state = beneficiaryService.lastBeneficiaryState;
        expect(state, BeneficiaryState.success);
        expect(beneficiaryService.beneficiaries.last, beneficiary);
        expect(beneficiaryService.beneficiaries.length, 1);
      });

      test('Add beneficiary with duplicate nickname', () {
        // Arrange

        // Act
        // Assert
      });

      test('Add beneficiary with empty nickname', () {
        // Arrange
        // Act
        // Assert
      });

      test('Add beneficiary with empty phone', () {
        // Arrange
        // Act
        // Assert
      });
    });

    group('Remove Beneficiary', () {
      test('Remove beneficiary', () {
        // Arrange
        // Act
        // Assert
      });

      test('Remove beneficiary not in the list', () {
        // Arrange
        // Act
        // Assert
      });
    });

    group('Update Beneficiary', () {
      test('Update beneficiary', () {
        // Arrange
        // Act
        // Assert
      });

      test('Update beneficiary not in the list', () {
        // Arrange
        // Act
        // Assert
      });
    });
  });
}
