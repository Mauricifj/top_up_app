import 'package:flutter/material.dart' hide BackButton;
import 'package:go_router/go_router.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../common/widgets/back_button.dart';
import '../../common/widgets/loading.dart';
import '../domain/beneficiary.dart';
import '../domain/beneficiary_service.dart';
import '../domain/beneficiary_state.dart';
import 'top_ups_page.dart';

class EditBeneficiaryPage extends StatefulWidget {
  static const String path = 'beneficiary';
  static const String route = '${TopUpsPage.route}/$path';

  final Beneficiary beneficiary;
  final BeneficiaryService beneficiaryService;

  const EditBeneficiaryPage({
    super.key,
    required this.beneficiary,
    required this.beneficiaryService,
  });

  @override
  State<EditBeneficiaryPage> createState() => _BeneficiaryPageState();
}

class _BeneficiaryPageState extends State<EditBeneficiaryPage> {
  final _nicknameController = TextEditingController();
  final _phoneController = TextEditingController();

  var phoneMaskFormatter = MaskTextInputFormatter(
    mask: '+971-5#-###-####',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.beneficiary.nickname;
    _phoneController.text = widget.beneficiary.phone;
  }

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [const BackButton(), _buildDeleteButton(context)],
                ),
                const SizedBox(height: 56.0),
                _buildTitle(),
                const SizedBox(height: 16.0),
                _buildWidgetForNickname(context),
                const SizedBox(height: 16.0),
                _buildWidgetForPhone(context),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: _buildConfirmButton(),
    );
  }

  IconButton _buildDeleteButton(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Beneficiary'),
              content: const Text(
                  'Are you sure you want to delete this beneficiary?'),
              actions: [
                TextButton(
                  onPressed: context.pop,
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await widget.beneficiaryService.removeBeneficiary(
                      widget.beneficiary,
                    );

                    final state =
                        widget.beneficiaryService.lastBeneficiaryState;
                    if (state == BeneficiaryState.success && context.mounted) {
                      context.go(TopUpsPage.route);
                    }
                    if (context.mounted) {
                      context.pop();
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          );
          widget.beneficiaryService.removeBeneficiary(widget.beneficiary);
        },
        icon: const Icon(Icons.delete));
  }

  Widget _buildTitle() {
    return Text(
      'Edit Beneficiary',
      style: Theme.of(context).textTheme.headlineMedium,
    );
  }

  Widget _buildWidgetForNickname(BuildContext context) {
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

  Widget _buildWidgetForPhone(BuildContext context) {
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
          onPressed: isLoading ? null : _updateBeneficiary,
          child: isLoading ? const Loading() : const Icon(Icons.check),
        );
      },
    );
  }

  void _updateBeneficiary() async {
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

    await widget.beneficiaryService.updateBeneficiary(
      widget.beneficiary,
      nickname,
      phone,
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
