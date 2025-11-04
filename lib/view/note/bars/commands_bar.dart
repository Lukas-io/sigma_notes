import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/colors.dart';

import '../../../core/assets.dart';
import '../../../services/providers/biometrics_provider.dart';
import '../../../services/providers/note_editor_provider.dart';
import '../../../services/providers/note_provider.dart';
import '../../widgets/commands/commands_list_item.dart';
import '../../widgets/commands/commands_row_button.dart';

class CommandsBar extends ConsumerWidget {
  final String noteId;

  const CommandsBar(this.noteId, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final note = ref.watch(noteEditorProvider(noteId)).value;

    final List<Widget> commands = [
      Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 8.0,
          top: 2,
        ),
        child: Row(
          spacing: 12,
          children: [
            Expanded(
              child: CommandsRowButton(
                title: 'Image',
                assetPath: SigmaAssets.commandImageSvg,
              ),
            ),
            Expanded(
              child: CommandsRowButton(
                title: 'Voice',
                assetPath: SigmaAssets.soundWaveSvg,
              ),
            ),
            Expanded(
              child: CommandsRowButton(
                title: 'Share',
                assetPath: SigmaAssets.commandShareSvg,
              ),
            ),
          ],
        ),
      ),
      CommandsListItem(
        title: (note?.isPinned ?? false) ? 'Pinned' : 'Pin',
        leading: SigmaAssets.pinSvg,
        onTap: () {
          ref
              .read(noteEditorProvider(noteId).notifier)
              .updateMetadata(
                isPinned: !(note?.isPinned ?? false),
                shouldSaveNow: true,
              );
        },
      ),
      CommandsListItem(
        title: note?.thumbnail != null ? 'Update thumbnail' : 'Add thumbnail',
        leading: SigmaAssets.commandThumbnailSvg,
      ),
      CommandsListItem(
        title: 'Label',
        leading: SigmaAssets.labelSvg,
        disclosureLabel: note?.label ?? "",
        isDisclosure: true,
      ),
      CommandsListItem(
        title: 'Send',
        leading: SigmaAssets.sendSvg,
        isDisclosure: true,
      ),
      CommandsListItem(
        title: 'Make a copy',
        leading: SigmaAssets.copyDocumentSvg,
      ),
      CommandsListItem(
        title: (note?.locked ?? false) ? "Remove lock" : "Lock note",
        leading: SigmaAssets.commandLockSvg,
        onTap: () async {
          // Read LocalAuthentication directly - it's keepAlive so won't dispose
          final auth = ref.read(localAuthProvider);

          // Use the service directly - no provider lifecycle issues
          final result = await BiometricService.authenticate(
            auth: auth,
            localizedReason: 'Unlock your Note',
          );

          // Check if widget is still mounted after async gap
          if (!context.mounted) return;

          log(result.toString());
          if (result.success) {
            ref
                .read(noteEditorProvider(noteId).notifier)
                .updateMetadata(
                  locked: !(note?.locked ?? false),
                  shouldSaveNow: true,
                );
          } else {
            //TODO: Show some error or use pin
            // Navigator.pop(context);
          }
        },
      ),
      CommandsListItem(
        title: 'Delete note',
        leading: SigmaAssets.deleteSvg,
        isDestructive: true,
        onTap: () {
          ref.read(notesProvider.notifier).deleteNote(noteId);
          Navigator.pop(context);
        },
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 24, right: 24),
        child: Text(
          "Last edited ${note?.formattedDateTime} by ${note?.userId}",
          textAlign: TextAlign.center,
          style: TextStyle(color: SigmaColors.gray, fontSize: 12),
        ),
      ),
    ];

    return ListView.separated(
      itemCount: commands.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(vertical: 16.0),

      itemBuilder: (context, index) => commands[index],
      separatorBuilder: (context, index) => const Divider(thickness: 0.25),
    ).animate().fadeIn(duration: 450.ms, curve: Curves.easeOut);
  }
}
