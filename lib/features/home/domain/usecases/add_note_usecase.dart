


import '../Entity/note.dart';
import '../repository/repository.dart';

class AddNoteUseCase {
  final NotesRepository repository;

  AddNoteUseCase(this.repository);

  Future<void> call(Note note) {
    return repository.addNote(note);
  }
}