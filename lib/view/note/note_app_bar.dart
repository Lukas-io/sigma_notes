import 'package:flutter/material.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/widgets/collaborator_widget.dart';
import 'package:sigma_notes/view/widgets/svg_button.dart';

import '../../core/colors.dart';

class NoteAppBar extends StatelessWidget {
  final NoteModel note;
  final NoteMode mode;

  const NoteAppBar(this.note, {super.key, this.mode = NoteMode.view});

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: SafeArea(
        bottom: false,

        child: SizedBox(
          height: kToolbarHeight,

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),

            child: Row(
              children: [
                // Left icon
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  switchOutCurve: Curves.easeOut,
                  switchInCurve: Curves.easeIn,
                  child: mode == NoteMode.view
                      ? SvgButton(
                          key: const ValueKey('back'),
                          assetPath: SigmaAssets.backSvg,
                          onTap: () => Navigator.pop(context),
                        )
                      : SvgButton(
                          key: const ValueKey('close'),
                          assetPath: SigmaAssets.xSvg,
                          iconSize: 20,
                          onTap: () => Navigator.pop(context),
                        ),
                ),

                Expanded(
                  child: Center(
                    child: !note.collaborators
                        ? null
                        : CollaboratorWidget(size: 36),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  switchOutCurve: Curves.easeOut,
                  switchInCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  ),
                  child: mode == NoteMode.view
                      ? SvgButton(
                          key: const ValueKey('edit'),
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
                        )
                      : SvgButton(
                          key: const ValueKey('check'),
                          assetPath: SigmaAssets.checkMarkSvg,
                          primary: true,
                          iconSize: 32,
                          shadows: [
                            BoxShadow(
                              spreadRadius: 12,
                              color: SigmaColors.card.withOpacity(0.5),
                              blurRadius: 12,
                            ),
                          ],
                          onTap: () {},
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
