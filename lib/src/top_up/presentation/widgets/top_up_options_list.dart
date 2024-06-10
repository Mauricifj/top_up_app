import 'package:flutter/material.dart';

class TopUpOptionsList extends StatefulWidget {
  final List<int> topUpOptions;
  final int selectedOption;
  final Function(int?) onChanged;
  final bool isLoading;

  const TopUpOptionsList({
    super.key,
    required this.topUpOptions,
    required this.selectedOption,
    required this.onChanged,
    required this.isLoading,
  });

  @override
  State<TopUpOptionsList> createState() => _TopUpsOptionsListState();
}

class _TopUpsOptionsListState extends State<TopUpOptionsList> {
  int selectedOption = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    isLoading = widget.isLoading;
    selectedOption = widget.selectedOption;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.topUpOptions.length,
      itemBuilder: (context, index) {
        final option = widget.topUpOptions[index];

        return RadioListTile<int>(
          value: option,
          groupValue: selectedOption,
          onChanged: isLoading
              ? null
              : (value) {
                  setState(() {
                    selectedOption = value!;
                  });
                  widget.onChanged(value);
                },
          title: Text(
            'AED ${(option / 100).toStringAsFixed(0)}',
          ),
        );
      },
    );
  }
}
