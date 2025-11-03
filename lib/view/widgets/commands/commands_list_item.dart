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

class CommandsListItem extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  final String leading;
  final bool isDestructive;
  final bool isDisclosure;
  final String disclosureLabel;

  const CommandsListItem({
    super.key,
    this.onTap,
    required this.title,
    required this.leading,
    this.isDestructive = false,
    this.isDisclosure = false,
    this.disclosureLabel = "",
  });

  @override
  Widget build(BuildContext context) {
    return SigmaInkwell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 24),
        child: Row(
          spacing: 12,
          children: [
            SvgPicture.asset(
              leading,
              color: isDestructive ? CupertinoColors.destructiveRed : null,
              width: 18,
              height: 18,
            ),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isDestructive ? CupertinoColors.destructiveRed : null,
                ),
              ),
            ),
            Text(disclosureLabel, style: TextStyle(color: SigmaColors.gray)),
            if (isDisclosure)
              SvgPicture.asset(SigmaAssets.frontSvg, width: 18, height: 18),
          ],
        ),
      ),
    );
  }
}
