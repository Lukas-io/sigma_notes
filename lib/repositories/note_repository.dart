import '../models/note.dart';

class NotesRepository {
  // For now, we'll use a mock list. Later you'll replace this with SQLite
  final List<NoteModel> _notes = [];

  // Get all notes
  Future<List<NoteModel>> getAllNotes() async {
    await Future.delayed(Duration(milliseconds: 500)); // Simulate database delay
    return List.from(_notes); // Return a copy
  }

  // Create a note
  Future<void> createNote(NoteModel note) async {
    await Future.delayed(Duration(milliseconds: 300));
    _notes.add(note);
  }

  // Update a note
  Future<void> updateNote(NoteModel note) async {
    await Future.delayed(Duration(milliseconds: 300));
    final index = _notes.indexWhere((n) => n.id == note.id);
    if (index != -1) {
      _notes[index] = note;
    }
  }

  // Delete a note
  Future<void> deleteNote(int id) async {
    await Future.delayed(Duration(milliseconds: 300));
    _notes.removeWhere((note) => note.id == id);
  }
}