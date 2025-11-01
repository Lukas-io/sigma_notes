import 'package:flutter/material.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/view/widgets/collaborator_widget.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

import '../../core/colors.dart';

class NoteAppBar extends StatelessWidget {
  const NoteAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: SizedBox(
        height: kToolbarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              SvgButton(
                assetPath: SigmaAssets.backSvg,
                onTap: () => Navigator.pop(context),
              ),
              Expanded(child: Center(child: CollaboratorWidget(size: 36))),
              SvgButton(
                assetPath: SigmaAssets.editSvg,
                primary: true,
                shadows: [
                  BoxShadow(
                    spreadRadius: 12,
                    color: SigmaColors.card.withOpacity(0.5),
                    blurRadius: 12,
                  ),
                ],
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
