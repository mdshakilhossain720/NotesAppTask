import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/note_model.dart';


class NotesRemoteDataSource {
  final FirebaseFirestore firestore;

  NotesRemoteDataSource(this.firestore);

  Stream<List<NoteModel>> getNotes() {
    return firestore
        .collection('notes')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return NoteModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> addNote(NoteModel note) async {
    await firestore.collection('notes').add(note.toMap());
  }
}