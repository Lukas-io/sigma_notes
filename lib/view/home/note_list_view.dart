import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:sigma_notes/core/assets.dart';
import 'package:sigma_notes/core/colors.dart';
import 'package:sigma_notes/core/router/routes.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/services/providers/note_provider.dart';
import 'package:sigma_notes/view/home/note_preview_widget.dart';
import 'package:sigma_notes/view/note/note_screen.dart';
import 'package:sigma_notes/view/widgets/sigma/sigma_ink_well.dart';
import 'package:uuid/uuid.dart';

import '../../core/utils/note_utils.dart';
import '../../models/content/text.dart';
import '../../services/providers/auth_provider.dart';
import '../../services/providers/search_provider.dart';

class NoteListView extends ConsumerWidget {
  final double minColumnWidth;

  final double columnSpacing;

  const NoteListView({
    super.key,
    this.minColumnWidth = 150,
    this.columnSpacing = 8,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the notes provider for async data

    final notesAsync = ref.watch(notesProvider);
    final query = ref.watch(searchQueryProvider);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;

        return notesAsync.when(
          data: (unfilterNotes) {
            final notes = unfilterNotes
                .where((note) => note.searchableText.contains(query))
                .toList();
            // Handle empty state
            if (unfilterNotes.isEmpty) {
              return SigmaInkwell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          NoteScreen(Uuid().v4(), mode: NoteMode.edit),
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 100.0,
                    horizontal: 36,
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        SigmaAssets.notebookSvg,
                        width: 60,
                        height: 60,
                        color: SigmaColors.gray,
                      ),
                      SizedBox(height: 12),

                      Text(
                        'Tap here to create \nyour first note',
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.2,
                          color: SigmaColors.gray,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            }

            // Compute number of columns based on minimum width + spacing
            int columnCount = (maxWidth / (minColumnWidth + columnSpacing))
                .floor();
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
            );
          },
          loading: () => Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 100.0,
              horizontal: 36,
            ),
            child: Center(
              child: CircularProgressIndicator.adaptive(
                strokeWidth: 2.5,
                strokeCap: StrokeCap.round,
              ),
            ),
          ),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                const Text('Failed to load notes'),
                const SizedBox(height: 8),
                Text(error.toString()),
              ],
            ),
          ),
        );
      },
    );
  }
}
