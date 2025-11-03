import 'package:flutter/material.dart';
import 'package:sigma_notes/models/content/content_model.dart';

import '../../widgets/divider/dividers.dart';

class ContentDivider extends StatelessWidget {
  final DividerContent content;

  const ContentDivider(this.content, {super.key});

  @override
  Widget build(BuildContext context) {
    switch (content.style) {
      case DividerStyle.solid:
        return const SolidDivider();

      case DividerStyle.dashed:
        return const DashedDivider();

      case DividerStyle.dotted:
        return const DottedDivider();

      case DividerStyle.doubleLine:
        return const DoubleLineDivider();

      case DividerStyle.decorative:
        return const DecorativeDivider();

      case DividerStyle.custom:
        return const CustomDivider();

      default:
        return const SizedBox.shrink();
    }
  }
}
