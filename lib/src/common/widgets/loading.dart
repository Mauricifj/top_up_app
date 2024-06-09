import 'package:flutter/material.dart';

class Loading extends StatelessWidget {
  final double size;
  final String? message;

  const Loading({
    super.key,
    this.size = 24,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: message != null
          ? Column(
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 8),
                Text(message!),
              ],
            )
          : const CircularProgressIndicator(),
    );
  }
}
