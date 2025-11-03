import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';

/// Placeholder widget for custom/experimental dividers.
class CustomDivider extends StatelessWidget {
  final Widget? child;
  final double height;
  final double horizontalPadding;

  const CustomDivider({
    super.key,
    this.child,
    this.height = 32,
    this.horizontalPadding = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
      child:
          child ??
          Container(
            height: height,
            alignment: Alignment.center,
            child: Text(
              "⚙️ Custom Divider",
              style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
            ),
          ),
    );
  }
}
