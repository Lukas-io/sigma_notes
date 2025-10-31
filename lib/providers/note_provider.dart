import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/note.dart';
import '../repositories/note_repository.dart';

part 'note_provider.g.dart';

@riverpod
NotesRepository notesRepository(Ref ref) {
  return NotesRepository();
}

@riverpod
class NotesNotifier extends _$NotesNotifier {
  @override
  Future<List<NoteModel>> build() async {
    return _loadNotes();
  }

  Future<List<NoteModel>> _loadNotes() async {
    final repository = ref.read(notesRepositoryProvider);
    return await repository.getAllNotes();
  }

  Future<void> createNote(NoteModel note) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      await repository.createNote(note);
      return _loadNotes();
    });
  }

  Future<void> updateNote(NoteModel note) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      await repository.updateNote(note);
      return _loadNotes();
    });
  }

  Future<void> deleteNote(int id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(notesRepositoryProvider);
      await repository.deleteNote(id);
      return _loadNotes();
    });
  }
}