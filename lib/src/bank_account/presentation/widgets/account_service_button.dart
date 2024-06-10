import 'package:flutter/material.dart';

class AccountServiceButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onPressed;

  const AccountServiceButton({
    super.key,
    required this.title,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(24.0);
    final borderColor = Theme.of(context).colorScheme.onPrimaryContainer;
    final backgroundColor = Theme.of(context).colorScheme.primaryContainer;
    final textColor = Theme.of(context).colorScheme.onPrimaryContainer;

    return InkWell(
      onTap: onPressed,
      borderRadius: borderRadius,
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: borderColor),
          borderRadius: borderRadius,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(icon, size: 24.0, color: textColor),
            Text(title, style: TextStyle(color: textColor)),
          ],
        ),
      ),
    );
  }
}
