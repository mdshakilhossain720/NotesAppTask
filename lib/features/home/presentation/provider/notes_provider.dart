import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import '../../data/remotedataSource/notes_remote_datasource.dart';
import '../../data/repositoryImpl/notes_repository_impl.dart';
import '../../domain/usecases/add_note_usecase.dart';
import '../../domain/usecases/get_notes_usecase.dart';

// Firebase
final firestoreProvider =
    Provider((ref) => FirebaseFirestore.instance);

// DataSource
final notesRemoteProvider =
    Provider((ref) => NotesRemoteDataSource(ref.read(firestoreProvider)));

// Repository
final notesRepositoryProvider =
    Provider((ref) => NotesRepositoryImpl(ref.read(notesRemoteProvider)));

// UseCases
final getNotesProvider =
    Provider((ref) => GetNotesUseCase(ref.read(notesRepositoryProvider)));

final addNoteProvider =
    Provider((ref) => AddNoteUseCase(ref.read(notesRepositoryProvider)));

// Stream Provider
final notesStreamProvider = StreamProvider((ref) {
  return ref.read(getNotesProvider).getNotes();
});