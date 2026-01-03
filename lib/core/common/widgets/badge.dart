import 'package:flutter/material.dart';

class UiBadge extends StatelessWidget {
  final String label;
  final IconData? icon;
  final Color color;
  final bool isOutline;

  const UiBadge({
    super.key,
    required this.label,
    this.icon,
    this.color = const Color(0xFF059669),
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isOutline
        ? Colors.transparent
        : color.withValues(alpha: 0.1);
    final fgColor = color;
    final borderColor = isOutline ? color : Colors.transparent;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Icon(icon, size: 14, color: fgColor),
            ),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: fgColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
