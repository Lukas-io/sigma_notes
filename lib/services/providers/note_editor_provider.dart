import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/collaborator.dart';
import '../../models/note.dart';
import '../../models/content/content_model.dart';
import '../repositories/temp_notes_repository.dart';
import 'auth_provider.dart';
import 'note_provider.dart';

part 'note_editor_provider.g.dart';

/// Manages note editing and persistence for a single note.
///
/// - Loads notes asynchronously via [AsyncNotifier].
/// - Auto-saves in-progress changes to a temporary database (`temp_notes`).
/// - Final saves go to the main notes database.
/// - Checks for changes before saving to avoid redundant writes.

/// Notes repository provider - kept alive since it's a lightweight singleton
@Riverpod(keepAlive: true)
TempNotesRepository tempNotesRepository(Ref ref) {
  return TempNotesRepository();
}

/// The goal is to keep the editing experience fluid and safe:
/// users never lose progress because temp saves happen automatically.
@riverpod
class NoteEditor extends _$NoteEditor {
  TempNotesRepository get _tempRepository =>
      ref.read(tempNotesRepositoryProvider);

  Timer? _autoSaveTimer;
  bool _isSaving = false;

  // Used to detect if something actually changed since last save
  String? _lastSavedJson;

  /// Builds the note editor state for a given [noteId].
  ///
  /// - Tries to load the note from cache.
  /// - If not in cache, fetches from the temp DB first (if unsynced work exists),
  ///   else falls back to the main repository.
  @override
  Future<NoteModel> build(String noteId) async {
    final notes = await ref
        .read(notesProvider.notifier)
        .fetchNotesForCurrentUser();
    String? currentUserId =
        ref.read(authProvider.notifier).getCurrentUser()?.id ?? "";

    // 1️⃣ Check if note already loaded in app memory
    final existing = notes.firstWhere(
      (note) => note.id == noteId,
      orElse: () => NoteModel(
        id: noteId,
        title: "Untitled document",
        userId: currentUserId,
      ),
    );
    ref.onDispose(() {
      _autoSaveTimer?.cancel();
    });

    // 2️⃣ If not in state, try to load from TEMP repo (unsynced draft)
    if (existing.userId.isEmpty) {
      final temp = await _tempRepository.getTempNoteById(noteId);
      if (temp != null) {
        _lastSavedJson = _serialize(temp);
        return temp;
      }

      // 3️⃣ Else load from MAIN repo
      final fetched = await ref
          .read(notesProvider.notifier)
          .getNoteById(noteId);
      if (fetched != null) {
        _lastSavedJson = _serialize(fetched);
        return fetched;
      }
    }

    _lastSavedJson = _serialize(existing);
    return existing;
  }

  /// Updates all metadata fields of the note except for its contents.
  void updateMetadata({
    String? title,
    String? thumbnail,
    String? label,
    bool? locked,
    bool? isTemp,
    bool? isPinned,
    List<Collaborator>? collaborators,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    bool shouldSaveNow = false,
  }) async {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      NoteModel(
        id: current.id,
        title: title ?? current.title,
        thumbnail: thumbnail ?? current.thumbnail,
        label: label ?? current.label,
        locked: locked ?? current.locked,
        isTemp: isTemp ?? current.isTemp,
        isPinned: isPinned ?? current.isPinned,
        collaborators: collaborators ?? current.collaborators,
        createdAt: createdAt ?? current.createdAt,
        updatedAt: updatedAt ?? current.updatedAt,
        userId: userId ?? current.userId,
        contents: current.contents, // keep the existing contents
      ),
    );

    _scheduleAutoSave();
    if (shouldSaveNow) await saveNow();
  }

  /// Replaces a content block at the same order and index position.
  ///
  /// It finds the original block by [oldContentId], replaces it with [newContent],
  /// and preserves the surrounding content order. Triggers a debounced auto-save.
  void replaceContent(String oldContentId, ContentModel newContent) {
    final current = state.value;
    if (current == null) return;

    final contents = current.contents;
    final oldIndex = contents.indexWhere((c) => c.id == oldContentId);

    if (oldIndex == -1) return;

    final updatedContent = newContent.copyWithOrder(contents[oldIndex].order);

    final updatedContents = List<ContentModel>.from(contents)
      ..[oldIndex] = updatedContent;

    state = AsyncData(current.copyWith(contents: updatedContents));
    _scheduleAutoSave();
  }

  /// Updates a specific content block.
  ///
  /// This replaces a content block by [contentId] and triggers a debounced auto-save.
  void updateContent(
    String contentId,
    ContentModel updatedContent, {
    bool showSaveNow = false,
  }) async {
    final current = state.value;
    if (current == null) return;

    final updatedContents = current.contents.map((c) {
      return c.id == contentId ? updatedContent : c;
    }).toList();
    state = AsyncData(current.copyWith(contents: updatedContents));
    if (!ref.mounted) return;
    if (showSaveNow) {
      await saveNow();
    } else {
      _scheduleAutoSave();
    }
  }

  /// Adds a new content block and schedules auto-save.
  void addContent(ContentModel newContent) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(
      current.copyWith(contents: [...current.contents, newContent]),
    );
    _scheduleAutoSave();
  }

  /// Deletes a content block and schedules auto-save.
  void deleteContent(String contentId) {
    final current = state.value;
    if (current == null) return;

    final updatedContents = current.contents
        .where((c) => c.id != contentId)
        .toList();

    state = AsyncData(current.copyWith(contents: updatedContents));
    _scheduleAutoSave();
  }

  /// Reorders content blocks (for drag-and-drop, etc.)
  void reorderContents(List<ContentModel> newOrder) {
    final current = state.value;
    if (current == null) return;

    state = AsyncData(current.copyWith(contents: newOrder));
    _scheduleAutoSave();
  }

  /// Debounced auto-save.
  ///
  /// Prevents saving every keystroke by waiting for a short pause (2 seconds).
  void _scheduleAutoSave() {
    if (!ref.mounted) return;
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(seconds: 2), _autoSaveIfChanged);
  }

  /// Saves to the TEMP database if changes are detected.
  ///
  /// This keeps autosave lightweight while ensuring edits are safe.
  Future<void> _autoSaveIfChanged() async {
    if (!ref.mounted) return;

    final current = state.value;
    if (current == null || _isSaving) return;

    final newJson = _serialize(current);
    if (newJson == _lastSavedJson) return; // nothing changed

    _isSaving = true;
    await _tempRepository.upsertTempNote(current);
    _lastSavedJson = newJson;
    _isSaving = false;
  }

  /// Manual save (e.g. user clicks “Save”).
  ///
  /// This flushes the temp note into the main `notes` database
  /// and removes its temporary version.
  Future<void> saveNow() async {
    _autoSaveTimer?.cancel();
    final current = state.value?.copyWith(updatedAt: DateTime.now());

    if (current == null) return;
    // Update the state correctly
    state = AsyncData(current);

    _isSaving = true;
    await ref.read(notesProvider.notifier).updateNote(current);
    await _tempRepository.deleteTempNote(current.id);
    _lastSavedJson = _serialize(current);

    _isSaving = false;
  }

  /// Converts a note to a JSON string for quick change detection.
  String _serialize(NoteModel note) => note.toMap().toString();
}
