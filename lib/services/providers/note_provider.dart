import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../models/note.dart';
import '../repositories/note_repository.dart';

part 'note_provider.g.dart';

@riverpod
NotesRepository notesRepository(Ref ref) {
  return NotesRepository();
}

@riverpod
class NotesNotifier extends _$NotesNotifier {
  String? _currentUserId;

  @override
  Future<List<NoteModel>> build() async {
    // We'll set the userId from auth provider later
    return [];
  }

  Future<void> loadNotesForUser(String userId) async {
    _currentUserId = userId;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      return await repository.getAllNotes(userId);
    });
  }

  Future<void> createNote(NoteModel note) async {
    if (_currentUserId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      await repository.createNote(note);
      return await repository.getAllNotes(_currentUserId!);
    });
  }

  Future<void> updateNote(NoteModel note) async {
    if (_currentUserId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      await repository.updateNote(note);
      return await repository.getAllNotes(_currentUserId!);
    });
  }

  Future<void> deleteNote(int id) async {
    if (_currentUserId == null) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      await repository.deleteNote(id);
      return await repository.getAllNotes(_currentUserId!);
    });
  }
}
