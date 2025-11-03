import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

class DoubleLineDivider extends StatelessWidget {
  final double spacing;
  final double thickness;
  final Color color;
  final double horizontalPadding;

  const DoubleLineDivider({
    super.key,
    this.spacing = 4,
    this.thickness = 1,
    this.color = SigmaColors.gray,
    this.horizontalPadding = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Divider(color: color, thickness: thickness),
          SizedBox(height: spacing),
          Divider(color: color, thickness: thickness),
        ],
      ),
    );
  }
}
