import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/note.dart';

import '../repositories/notes_repository.dart';
import 'auth_provider.dart';

part 'note_provider.g.dart';

/// Notes repository provider - kept alive since it's a lightweight singleton
@Riverpod(keepAlive: true)
NotesRepository notesRepository(Ref ref) {
  return NotesRepository();
}

/// Notes state notifier
@riverpod
class NotesNotifier extends _$NotesNotifier {
  String? _currentUserId;

  @override
  Future<List<NoteModel>> build() async {
    // Try to auto-load notes for the current authenticated user
    final user = ref.read(authProvider.notifier).getCurrentUser();
    if (user != null) {
      _currentUserId = user.id;
      return loadNotesForCurrentUser();
    }
    return [];
  }

  /// Loads notes from the repository without modifying provider state
  Future<List<NoteModel>> fetchNotesForCurrentUser() async {
    if (_currentUserId == null) {
      final user = ref.read(authProvider.notifier).getCurrentUser();
      if (user == null) return [];
      _currentUserId = user.id;
    }

    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return state.value ?? [];

    final repository = ref.read(notesRepositoryProvider);
    // Check if the provider is still mounted before accessing repository
    if (!ref.mounted) return state.value ?? [];
    return repository.getAllNotes(_currentUserId!);
  }

  /// Load all notes for the current authenticated user
  Future<List<NoteModel>> loadNotesForCurrentUser() async {
    if (_currentUserId == null) {
      final user = ref.read(authProvider.notifier).getCurrentUser();
      if (user == null) return [];
      _currentUserId = user.id;
    }

    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return state.value ?? [];

    state = const AsyncValue.loading();

    // Check if the provider is still mounted after setting loading state
    if (!ref.mounted) return state.value ?? [];

    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      // Check if the provider is still mounted before accessing repository
      if (!ref.mounted) return state.value ?? [];
      return repository.getAllNotes(_currentUserId!);
    });

    return state.value ?? [];
  }

  /// Create a new note and refresh state
  Future<void> createNote(NoteModel note) async {
    if (_currentUserId == null) return;

    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;

    state = const AsyncValue.loading();

    // Check if the provider is still mounted after setting loading state
    if (!ref.mounted) return;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      // Check if the provider is still mounted before accessing repository
      if (!ref.mounted) return state.value ?? [];
      await repository.createNote(note);
      // Check if the provider is still mounted after creating note
      if (!ref.mounted) return state.value ?? [];
      return repository.getAllNotes(_currentUserId!);
    });
  }

  /// Fetches a single note by its [id].
  /// Returns the note and refreshes the state for consistency.
  Future<NoteModel?> getNoteById(String id) async {
    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return null;

    state = const AsyncValue.loading();

    // Check if the provider is still mounted after setting loading state
    if (!ref.mounted) return null;

    state = await AsyncValue.guard<List<NoteModel>>(() async {
      final repository = ref.read(notesRepositoryProvider);
      // Check if the provider is still mounted before accessing repository
      if (!ref.mounted) return state.value ?? <NoteModel>[];
      final note = await repository.getNoteById(id);

      // If no note found, just return existing state list (or empty)
      if (note == null) {
        return state.value ?? <NoteModel>[];
      }

      // Update/insert the fetched note into the current list
      final List<NoteModel> currentNotes = state.value ?? <NoteModel>[];
      final updated = [...currentNotes.where((n) => n.id != note.id), note];

      return updated;
    });

    // Return the specific note
    final List<NoteModel> notes = state.value ?? <NoteModel>[];
    try {
      return notes.firstWhere((n) => n.id == id);
    } catch (_) {
      return null;
    }
  }

  /// Update an existing note and refresh state
  Future<void> updateNote(NoteModel note) async {
    if (_currentUserId == null) return;

    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;

    state = const AsyncValue.loading();

    // Check if the provider is still mounted after setting loading state
    if (!ref.mounted) return;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      // Check if the provider is still mounted before accessing repository
      if (!ref.mounted) return state.value ?? [];
      await repository.updateNote(note);
      // Check if the provider is still mounted after updating note
      if (!ref.mounted) return state.value ?? [];
      return await repository.getAllNotes(_currentUserId!);
    });
  }

  /// Delete a note by ID and refresh state
  Future<void> deleteNote(String id) async {
    if (_currentUserId == null) return;

    // Check if the provider is still mounted before proceeding
    if (!ref.mounted) return;

    state = const AsyncValue.loading();

    // Check if the provider is still mounted after setting loading state
    if (!ref.mounted) return;

    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      // Check if the provider is still mounted before accessing repository
      if (!ref.mounted) return state.value ?? [];
      await repository.deleteNote(id);
      // Check if the provider is still mounted after deleting note
      if (!ref.mounted) return state.value ?? [];
      return repository.getAllNotes(_currentUserId!);
    });
  }

  /// Create a brand new blank note for the current user
  NoteModel createBlankNote({String title = "Untitled document"}) {
    if (_currentUserId == null) {
      final user = ref.read(authProvider.notifier).getCurrentUser();
      if (user == null) {
        throw Exception("No current user found");
      }
      _currentUserId = user.id;
    }

    return NoteModel(title: title, userId: _currentUserId!, contents: []);
  }
}
