import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/services/providers/note_editor_provider.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';
import 'package:uuid/uuid.dart';

import '../../core/colors.dart';
import '../../models/content/text.dart';
import '../../services/providers/note_mode_provider.dart';
import '../widgets/collaborator_widget.dart';

class NoteAppBar extends ConsumerWidget {
  final String noteId;

  const NoteAppBar(this.noteId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(noteModeStateProvider);

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
                SigmaInkwell(
                  onTap: () {
                    ref
                        .read(noteModeStateProvider.notifier)
                        .setMode(NoteMode.view);

                    Navigator.pop(context);
                  },

                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 12,
                          color: SigmaColors.card.withOpacity(0.5),
                          blurRadius: 12,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(360),
                    ),
                    clipBehavior: Clip.none,
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        ),
                        switchOutCurve: Curves.easeOut,
                        switchInCurve: Curves.easeIn,
                        child: mode == NoteMode.view
                            ? SvgPicture.asset(
                                key: ValueKey('back'),
                                SigmaAssets.backSvg,
                                width: 24,
                                height: 24,
                              )
                            : SvgPicture.asset(
                                key: ValueKey('close'),
                                SigmaAssets.xSvg,
                                width: 18,
                                height: 18,
                              ),
                      ),
                    ),
                  ),
                ),

                Expanded(
                  child: Center(
                    child: CollaboratorWidget(size: 36, noteId: noteId),
                  ),
                ),

                SigmaInkwell(
                  onTap: () {
                    // Change mode
                    ref
                        .read(noteModeStateProvider.notifier)
                        .setMode(
                          mode == NoteMode.view ? NoteMode.edit : NoteMode.view,
                        );

                    // // Add TextContent if content is empty on edit.
                    // final note = ref.read(noteEditorProvider(noteId)).value;
                    // if (mode == NoteMode.edit &&
                    //     (note?.contents.isEmpty ?? false)) {
                    //   ref
                    //       .read(noteEditorProvider(noteId).notifier)
                    //       .addContent(TextContent(text: '', order: 0));
                    // }

                    // Save note
                    if (mode == NoteMode.edit) {
                      ref.read(noteEditorProvider(noteId).notifier).saveNow();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          spreadRadius: 12,
                          color: SigmaColors.card.withOpacity(0.5),
                          blurRadius: 12,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(360),
                    ),
                    clipBehavior: Clip.none,
                    child: CircleAvatar(
                      radius: 44 / 2,

                      backgroundColor: SigmaColors.black,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: ScaleTransition(
                            scale: animation,
                            child: child,
                          ),
                        ),
                        switchOutCurve: Curves.easeOut,
                        switchInCurve: Curves.easeIn,
                        child: mode == NoteMode.view
                            ? SvgPicture.asset(
                                key: const ValueKey('edit'),
                                SigmaAssets.editSvg,
                                color: SigmaColors.white,
                              )
                            : SvgPicture.asset(
                                key: const ValueKey('check'),
                                SigmaAssets.checkMarkSvg,

                                color: SigmaColors.white,
                                width: 32,
                                height: 32,
                              ),
                      ),
                    ),
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
