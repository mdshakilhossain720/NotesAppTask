import '../Entity/note.dart';

abstract class NotesRepository {
  Stream<List<Note>> getNotes();
  Future<void> addNote(Note note);
}