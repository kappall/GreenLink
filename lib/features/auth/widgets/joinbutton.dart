import 'package:flutter/material.dart';

class JoinButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool? isLoading;
  final String label;
  final bool invert;

  const JoinButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    required this.label,
    this.invert = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: isLoading! ? null : onPressed,
        style: invert
            ? FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: colorScheme.primary,
                side: BorderSide(color: colorScheme.primary),
              )
            : null,
        child: isLoading!
            ? SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: invert ? colorScheme.primary : Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(label),
      ),
    );
  }
}
