import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/note/content/content_widget.dart';
import 'package:sigma_notes/view/note/content/title_widget.dart';
import 'package:sigma_notes/view/note/content/checklist_content_widget.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/note/content/audio_content_widget.dart';
import 'package:sigma_notes/view/widgets/divider/dotted_divider.dart';

import 'content/label_widget.dart';

class NoteScreenContent extends StatefulWidget {
  final NoteModel note;
  final NoteMode mode;

  const NoteScreenContent(this.note, {super.key, this.mode = NoteMode.view});

  @override
  State<NoteScreenContent> createState() => _NoteScreenContentState();
}

class _NoteScreenContentState extends State<NoteScreenContent> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
        print("unfocus");
      },
      child: SingleChildScrollView(
        padding: EdgeInsetsGeometry.symmetric(
          horizontal: 16,
          vertical: 16 + kToolbarHeight,
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TitleWidget(widget.note.title.trim(), noteId: widget.note.id),

              LabelWidget(
                label: widget.note.label,
                updatedDate: widget.note.formattedDateDayTime,
              ),

              SizedBox(height: 20),

              ...widget.note.contents.map(
                (content) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ContentWidget(
                    content: content,
                    noteId: widget.note.id,
                  ),
                ),
              ),
              SizedBox(height: 250),
            ],
          ),
        ),
      ),
    );
  }
}
