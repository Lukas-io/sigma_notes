import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/note/note_check_list_item.dart';
import 'package:sigma_notes/view/note/voice_note_widget.dart';
import 'package:sigma_notes/view/widgets/dotted_divider.dart';

import '../../models/check_list_item.dart';

class NoteScreenContent extends StatelessWidget {
  final NoteModel note;

  const NoteScreenContent(this.note, {super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsetsGeometry.symmetric(
        horizontal: 16,
        vertical: 16 + kToolbarHeight,
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title.trim(),
              style: TextStyle(
                color: SigmaColors.black,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.3,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "${note.label} ｜ ${note.formattedDateDayTime}",
              style: TextStyle(
                color: SigmaColors.gray,
                fontSize: 12,
                height: 1.3,
              ),
            ),
            SizedBox(height: 20),

            SelectableText(note.content.trim(), style: TextStyle(fontSize: 16)),
            SizedBox(height: 16),

            VoiceNoteWidget(
              duration: const Duration(minutes: 1, seconds: 24),
              isPlaying: false,
            ),
            DottedDivider(),
            Text(
              "1. Look at me",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sampleCheckList1.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = sampleCheckList1[index];
                return NoteCheckListItem(
                  model: item,
                  size: CheckListSize.normal,
                );
              },
            ),
            SizedBox(height: 12),
            Text(
              "2. I am a fucking star!",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: sampleCheckList2.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = sampleCheckList2[index];
                return NoteCheckListItem(
                  model: item,
                  size: CheckListSize.normal,
                );
              },
            ),
            SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
