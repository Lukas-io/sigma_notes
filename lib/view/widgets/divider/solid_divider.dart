import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

class SolidDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final Color color;
  final double horizontalPadding;

  const SolidDivider({
    super.key,
    this.thickness = 1.2,
    this.height = 32,
    this.color = SigmaColors.gray,
    this.horizontalPadding = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child: Divider(height: height, thickness: thickness, color: color),
    );
  }
}
