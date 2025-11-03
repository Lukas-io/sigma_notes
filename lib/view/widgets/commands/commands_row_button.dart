import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';

import '../../../../core/assets.dart';
import '../../../../services/providers/note_editor_provider.dart';

class CommandsRowButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String assetPath;

  const CommandsRowButton({
    super.key,
    this.onTap,
    required this.title,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return SigmaInkwell(
      child: Container(
        padding: EdgeInsetsGeometry.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: SigmaColors.card,
          borderRadius: SmoothBorderRadius(
            cornerRadius: 12,
            cornerSmoothing: 1,
          ),
        ),
        child: Column(
          spacing: 4,
          children: [
            SvgPicture.asset(assetPath, width: 30, height: 30),
            Text(title),
          ],
        ),
      ),
    );
  }
}
