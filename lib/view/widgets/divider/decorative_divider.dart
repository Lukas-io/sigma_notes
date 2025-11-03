import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

class DecorativeDivider extends StatelessWidget {
  final String symbol;
  final Color color;
  final double fontSize;
  final EdgeInsets padding;

  const DecorativeDivider({
    super.key,
    this.symbol = '✦ ✦ ✦',
    this.color = SigmaColors.gray,
    this.fontSize = 14,
    this.padding = const EdgeInsets.symmetric(vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: Text(
          symbol,
          style: TextStyle(color: color, fontSize: fontSize, letterSpacing: 4),
        ),
      ),
    );
  }
}
