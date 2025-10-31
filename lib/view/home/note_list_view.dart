import 'package:flutter/material.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/home/note_preview_widget.dart';

import 'package:flutter/material.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/view/home/note_preview_widget.dart';

class NoteListView extends StatelessWidget {
  final List<NoteModel> notes;

  const NoteListView(this.notes, {super.key});

  static const double minColumnWidth = 150;
  static const double columnSpacing = 8;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        // Compute number of columns based on minimum width + spacing
        int columnCount = (maxWidth / (minColumnWidth + columnSpacing)).floor();
        columnCount = columnCount.clamp(1, 6); // Optional safety clamp

        // Distribute notes across columns
        final List<List<NoteModel>> columns = List.generate(
          columnCount,
          (_) => [],
        );
        for (int i = 0; i < notes.length; i++) {
          columns[i % columnCount].add(notes[i]);
        }

        return ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: columnSpacing,
                children: [
                  for (int i = 0; i < columns.length; i++) ...[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final note in columns[i])
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: NotePreviewWidget(note),
                            ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
