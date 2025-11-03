import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/services/providers/note_bar_provider.dart';
import 'package:sigma_notes/view/note/note_bottom_bar.dart';

import '../../../core/assets.dart';
import '../../widgets/svg_button.dart';

class EditBar extends ConsumerWidget {
  const EditBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SvgButton(
            onTap: () {
              ref
                  .read(noteBarTypeStateProvider.notifier)
                  .setBarType(NoteBarType.draw);
            },
            assetPath: SigmaAssets.standardDrawSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {
              ref
                  .read(noteBarTypeStateProvider.notifier)
                  .setBarType(NoteBarType.voice);
            },
            assetPath: SigmaAssets.microphoneSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {
              ref
                  .read(noteBarTypeStateProvider.notifier)
                  .setBarType(NoteBarType.layout);
            },
            assetPath: SigmaAssets.standardLayoutSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {
              ref
                  .read(noteBarTypeStateProvider.notifier)
                  .setBarType(NoteBarType.text);
            },
            assetPath: SigmaAssets.standardTextSvg,
            filled: false,
          ),
          SvgButton(
            onTap: () {
              ref
                  .read(noteBarTypeStateProvider.notifier)
                  .setBarType(NoteBarType.commands);
            },
            assetPath: SigmaAssets.standardCommandSvg,
            filled: false,
          ),
        ],
      ).animate().fadeIn(duration: 600.ms, curve: Curves.easeOut),
    );
  }
}
