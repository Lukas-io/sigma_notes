import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sigma_notes/models/note.dart';
import 'package:sigma_notes/services/providers/note_provider.dart';

part 'search_provider.g.dart';

/// Search query provider
@Riverpod(keepAlive: true)
class SearchQuery extends _$SearchQuery {
  @override
  String build() {
    return '';
  }

  void setQuery(String query) {
    state = query.toLowerCase().trim();
  }
}

/// Filtered notes provider
@riverpod
class FilteredNotes extends _$FilteredNotes {
  @override
  List<NoteModel> build() {
    final notesAsync = ref.watch(notesProvider);
    final query = ref.watch(searchQueryProvider);

    // Handle the async state of notes
    if (notesAsync is AsyncLoading) {
      return []; // Return empty list while loading
    }

    if (notesAsync is AsyncError) {
      return []; // Return empty list on error
    }

    final notes = notesAsync.value ?? [];

    if (query.isEmpty) {
      return [];
    }

    return notes.where((note) {
      // Search in title
      if (note.title.toLowerCase().contains(query)) {
        return true;
      }
      if (note.formattedDateDayTime.contains(query)) {
        return true;
      }
      if ((note.label?.toLowerCase() ?? "").contains(query)) {
        return true;
      }

      // Search in all content blocks
      for (final content in note.contents) {
        final searchableText = content.getSearchableText().toLowerCase();
        if (searchableText.contains(query)) {
          return true;
        }
      }

      return false;
    }).toList();
  }
}
