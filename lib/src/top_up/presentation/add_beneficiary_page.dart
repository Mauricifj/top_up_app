import 'package:flutter/material.dart' hide BackButton;
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../common/widgets/back_button.dart';
import '../../common/widgets/loading.dart';
import '../domain/beneficiary.dart';
import '../domain/beneficiary_service.dart';
import '../domain/beneficiary_state.dart';
import 'top_ups_page.dart';

class AddBeneficiaryPage extends StatefulWidget {
  static const String path = 'add-beneficiary';
  static const String route = '${TopUpsPage.route}/$path';

  final BeneficiaryService beneficiaryService;

  final String? id;

  const AddBeneficiaryPage({
    super.key,
    required this.id,
    required this.beneficiaryService,
  });

  @override
  State<AddBeneficiaryPage> createState() => _BeneficiaryPageState();
}

class _BeneficiaryPageState extends State<AddBeneficiaryPage> {
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();

  var phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+971-5#-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

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
                _buildTitle(),
                const SizedBox(height: 16.0),
                _buildInputForNickname(context),
                const SizedBox(height: 16.0),
                _buildInputForPhone(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildConfirmButton(),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Add Beneficiary',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildInputForNickname(BuildContext context) {
    return TextFormField(
      controller: _nicknameController,
      decoration: const InputDecoration(
        labelText: 'Nickname',
        hintText: 'Enter a nickname',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a nickname';
        }
        if (value.length > 20) {
          return 'Nickname must be less than 20 characters';
        }
        return null;
      },
    );
  }

  Widget _buildInputForPhone(BuildContext context) {
    return TextFormField(
      controller: _phoneController,
      decoration: const InputDecoration(
        labelText: 'Phone',
        hintText: 'Enter a phone number',
      ),
      keyboardType: TextInputType.phone,
      inputFormatters: [phoneMaskFormatter],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a phone number';
        }
        return null;
      },
    );
  }

  Widget _buildConfirmButton() {
    return ListenableBuilder(
      listenable: widget.beneficiaryService,
      builder: (context, _) {
        final beneficiaryState = widget.beneficiaryService.lastBeneficiaryState;
        final isLoading = beneficiaryState == BeneficiaryState.loading;

        return FloatingActionButton(
          onPressed: isLoading ? null : _addBeneficiary,
          child: isLoading ? const Loading() : const Icon(Icons.chevron_right),
        );
      },
    );
  }

  void _addBeneficiary() async {
    final nickname = _nicknameController.text;
    if (nickname.isEmpty || nickname.length > 20) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid nickname number'),
        ),
      );
      return;
    }

    final phone = phoneMaskFormatter.getMaskedText();
    if (phone.isEmpty || !phoneMaskFormatter.isFill()) {
      final scaffoldMessenger = ScaffoldMessenger.of(context);
      scaffoldMessenger.clearSnackBars();
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid phone number'),
        ),
      );
      return;
    }

    await widget.beneficiaryService.addBeneficiary(
      Beneficiary(
        uid: DateTime.now().millisecondsSinceEpoch.toString(),
        nickname: nickname,
        phone: phone,
      ),
    );

    final state = widget.beneficiaryService.lastBeneficiaryState;
    switch (state) {
      case BeneficiaryState.success:
        if (mounted) {
          context.pop();
        }
        break;
      case BeneficiaryState.duplicateNickname:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nickname already exists'),
            ),
          );
        }
        break;
      case BeneficiaryState.duplicatePhone:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Phone number already exists'),
            ),
          );
        }
        break;
      case BeneficiaryState.limitReached:
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You can only add up to 5 beneficiaries'),
            ),
          );
        }
        break;
      default:
        break;
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
