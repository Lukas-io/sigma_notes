import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';
import 'package:sprung/sprung.dart';

import '../../core/assets.dart';
import '../../services/providers/note_bar_provider.dart';
import '../../services/providers/recorder_provider.dart';
import '../widgets/svg_button.dart';
import 'bars/commands_bar.dart';
import 'bars/draw_bar.dart';
import 'bars/layout_bar.dart';
import 'bars/minimal_bar.dart';
import 'bars/edit_bar.dart';
import 'bars/text_bar.dart';
import 'bars/voice_bar.dart';

enum NoteBarType { minimal, edit, text, draw, layout, commands, voice }

class NoteBottomBar extends ConsumerWidget {
  final String noteId;

  const NoteBottomBar(this.noteId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final type = ref.watch(noteBarTypeStateProvider);

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: MediaQuery.widthOf(context) - 32),
      child: Material(
        elevation: 75,
        color: SigmaColors.white.withOpacity(0),
        shadowColor: SigmaColors.gray.withOpacity(0.25),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              alignment: AlignmentGeometry.centerRight,
              padding: EdgeInsetsGeometry.only(right: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),

                switchInCurve: Curves.easeOutBack,
                switchOutCurve: Curves.easeInBack,
                transitionBuilder: (child, animation) {
                  return ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child:
                    type == NoteBarType.voice &&
                        (ref.read(recorderProvider).value?.isRecording ?? false)
                    ? SvgButton(
                        key: const ValueKey('checkButton'),
                        assetPath: SigmaAssets.checkMarkSvg,
                        primary: true,
                        iconSize: 32,
                        // size: 48,
                        onTap: () {
                          final audioContent = ref
                              .read(recorderProvider.notifier)
                              .toAudioContent(order: 9);
                        },
                      )
                    : const SizedBox(key: ValueKey('emptySpace')),
              ),
            ),
            AnimatedSize(
              duration: Duration(milliseconds: 300),
              curve: Curves.easeOut,
              child: type != NoteBarType.edit && type != NoteBarType.minimal
                  ? SigmaInkwell(
                      onTap: () {
                        ref
                            .read(noteBarTypeStateProvider.notifier)
                            .setBarType(NoteBarType.edit);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: SigmaColors.card),
                            color: Colors.white,
                            borderRadius: SmoothBorderRadius(
                              cornerRadius: 16,
                              cornerSmoothing: 1,
                            ),
                          ),
                          height: 6,
                          width: 52,
                        ),
                      ),
                    )
                  : SizedBox(width: 52),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: SigmaColors.card),
                color: Colors.white,
                borderRadius: SmoothBorderRadius(
                  cornerRadius: 16,
                  cornerSmoothing: 1,
                ),
              ),
              child: AnimatedSize(
                duration: 750.ms,
                curve: Sprung(28),
                child: AnimatedSwitcher(
                  duration: 150.ms,
                  switchInCurve: Sprung(28),
                  switchOutCurve: Sprung(28),
                  child: switch (type) {
                    NoteBarType.edit => EditBar(),
                    NoteBarType.text => TextBar(),
                    NoteBarType.voice => VoiceBar(),
                    NoteBarType.draw => DrawBar(),
                    NoteBarType.layout => LayoutBar(),
                    NoteBarType.commands => CommandsBar(noteId),
                    NoteBarType.minimal => MinimalBar(),
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
