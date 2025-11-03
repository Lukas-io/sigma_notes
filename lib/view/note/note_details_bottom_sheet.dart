import 'dart:ui';

import 'package:figma_squircle/figma_squircle.dart';
import 'package:flutter/material.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/widgets/collaborator_widget.dart';

import '../../services/providers/auth_provider.dart';
import '../widgets/commands/commands_list_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sigma_notes/core/colors.dart';

import '../../../core/assets.dart';
import '../../../services/providers/note_editor_provider.dart';

class NoteDetailsBottomSheet extends ConsumerWidget {
  final NoteModel note;

  const NoteDetailsBottomSheet(this.note, {super.key});

  static void show(BuildContext context, NoteModel note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NoteDetailsBottomSheet(note),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(noteEditorProvider(note.id).notifier);
    final List<Widget> commands = [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 2,
          children: [
            Text(
              note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: SigmaColors.black,
                fontSize: 18,
                height: 1,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              "Last edited ${note.formattedDateTime} by ${ref.read(authProvider.notifier).getCurrentUser()?.id == note.userId ? "You" : "Collaborator"}",
              style: TextStyle(
                color: SigmaColors.gray,
                fontSize: 12,

                height: 1,
              ),
            ),
          ],
        ),
      ),
      CommandsListItem(
        title: (note.isPinned) ? 'Pinned' : 'Pin',
        leading: SigmaAssets.pinSvg,
        onTap: () {
          ref
              .read(noteEditorProvider(note.id).notifier)
              .updateMetadata(isPinned: !note.isPinned, shouldSaveNow: true);
          Navigator.pop(context);
        },
      ),
      CommandsListItem(
        title: note.thumbnail != null ? 'Update thumbnail' : 'Add thumbnail',
        leading: SigmaAssets.commandThumbnailSvg,
        onTap: () {},
      ),
      CommandsListItem(
        title: 'Label',
        leading: SigmaAssets.labelSvg,
        disclosureLabel: note.label ?? "",
        isDisclosure: true,
        onTap: () {},
      ),
      CommandsListItem(
        title: 'Send',
        leading: SigmaAssets.sendSvg,
        isDisclosure: true,
        onTap: () {},
      ),
      CommandsListItem(
        title: 'Make a copy',
        leading: SigmaAssets.copyDocumentSvg,
        onTap: () {},
      ),
      CommandsListItem(
        title: (note.locked) ? "Remove lock" : "Lock note",
        leading: SigmaAssets.commandLockSvg,
        onTap: () {},
      ),
      CommandsListItem(
        title: 'Delete note',
        leading: SigmaAssets.deleteSvg,
        isDestructive: true,
        onTap: () {},
      ),
      // if (note.collaborators.isNotEmpty)
      Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        alignment: AlignmentGeometry.center,
        child: CollaboratorWidget(size: 32),
      ),
    ];

    return BackdropFilter(
      filter: ImageFilter.blur(sigmaY: 4, sigmaX: 4),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: SmoothBorderRadius.only(
            topLeft: SmoothRadius(cornerRadius: 32, cornerSmoothing: 1),
            topRight: SmoothRadius(cornerRadius: 32, cornerSmoothing: 1),
          ),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    border: Border.all(color: SigmaColors.card),
                    color: SigmaColors.gray,
                    borderRadius: SmoothBorderRadius(
                      cornerRadius: 16,
                      cornerSmoothing: 1,
                    ),
                  ),
                  height: 6,
                  width: 52,
                ),
                ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsetsGeometry.only(bottom: 12),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: commands.length,
                  itemBuilder: (context, index) => commands[index],
                  separatorBuilder: (_, __) => const Divider(thickness: 0.25),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
