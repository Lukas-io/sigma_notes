import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/note.dart';
import '../../models/content/content_model.dart';
import '../repositories/note_repository.dart';
import 'note_provider.dart';

part 'note_editor_provider.g.dart';

/// A provider that manages note editing state and persistence for a single note.
///
/// This uses [AsyncNotifier] so that the note is loaded asynchronously,
/// and then changes to the note (like content updates, adding, deleting)
/// are tracked and saved automatically to the database.
@riverpod
class NoteEditor extends _$NoteEditor {
  NotesRepository get _repository => ref.read(notesRepositoryProvider);

  Timer? _autoSaveTimer;
  bool _isSaving = false;

  /// Builds the note editor state for a given [noteId].
  ///
  /// It first tries to fetch the note from [NotesNotifier] (already cached notes).
  /// If not found, it fetches directly from the database.
  @override
  Future<NoteModel> build(String noteId) async {
    final notesNotifier = ref.read(notesProvider.notifier);
    final notes = await notesNotifier.loadNotesForCurrentUser();

    // Try to find the note in already loaded notes
    final existing = notes.firstWhere(
      (note) => note.id == noteId,
      orElse: () => NoteModel(
        id: noteId,
        title: "Untitled document",
        userId: "", // placeholder, should be replaced by real user id
      ),
    );

    // If not found in state, fetch from repository
    if (existing.userId.isEmpty) {
      final fetched = await _repository.getNoteById(noteId);
      if (fetched != null) return fetched;
    }

    return existing;
  }

  /// Updates a specific content block within the note.
  ///
  /// This searches for the content with the matching [contentId] and replaces it
  /// with [updatedContent]. Then it schedules an automatic save.
  void updateContent(String contentId, ContentModel updatedContent) {
    final current = state.value;
    if (current == null) return;

    final updatedContents = current.contents.map((c) {
      return c.id == contentId ? updatedContent : c;
    }).toList();

    state = AsyncData(current.copyWith(contents: updatedContents));
    _scheduleAutoSave();
  }

  /// Adds a new content block to the note and schedules an auto-save.
  void addContent(ContentModel newContent) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(contents: [...current.contents, newContent]),
    );
    _scheduleAutoSave();
  }

  /// Deletes a content block by ID and schedules an auto-save.
  void deleteContent(String contentId) {
    final current = state.value;
    if (current == null) return;

    final updatedContents = current.contents
        .where((c) => c.id != contentId)
        .toList();

    state = AsyncData(current.copyWith(contents: updatedContents));
    _scheduleAutoSave();
  }

  /// Reorders the note contents (e.g., drag-and-drop reordering in the UI).
  void reorderContents(List<ContentModel> newOrder) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(contents: newOrder));
    _scheduleAutoSave();
  }

  /// Schedules a delayed automatic save to minimize frequent writes.
  ///
  /// A debounce-style mechanism ensures that the database save happens only
  /// after the user pauses editing for a few seconds.
  void _scheduleAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), saveToDb);
  }

  /// Saves the current note to the database immediately.
  ///
  /// This is used by the auto-save system or can be called manually.
  Future<void> saveToDb() async {
    if (_isSaving) return;
    final current = state.value;
    if (current == null) return;

    _isSaving = true;
    await _repository.updateNote(current);
    _isSaving = false;
  }

  /// Manually trigger a save (for "Save" button actions, etc.)
  Future<void> saveNow() async {
    _autoSaveTimer?.cancel();
    await saveToDb();
  }
}
