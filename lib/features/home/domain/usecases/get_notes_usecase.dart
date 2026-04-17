

import '../repository/repository.dart';

class GetNotesUseCase {
  final NotesRepository repository;

  GetNotesUseCase(this.repository);

  Stream getNotes() {
    return repository.getNotes();
  }
}