

import '../../domain/Entity/note.dart';
import '../../domain/repository/repository.dart';
import '../model/note_model.dart';
import '../remotedataSource/notes_remote_datasource.dart';

class NotesRepositoryImpl implements NotesRepository {
  final NotesRemoteDataSource remote;

  NotesRepositoryImpl(this.remote);

  @override
  Stream<List<Note>> getNotes() {
    return remote.getNotes();
  }

  @override
  Future<void> addNote(Note note) {
    final model = NoteModel(
      id: note.id,
      title: note.title,
      description: note.description,
      createdAt: note.createdAt,
    );

    return remote.addNote(model);
  }
}