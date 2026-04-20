import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:note_flow/features/notes/domain/note_model.dart';

class FirestoreNotesDatasource {
  final FirebaseFirestore _firestore;

  FirestoreNotesDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _userNotesCollection(String userId) {
    return _firestore.collection('users').doc(userId).collection('notes');
  }

  Stream<List<NoteModel>> watchNotes(String userId) {
    return _userNotesCollection(userId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => NoteModel.fromFirestore(doc.data()))
            .toList());
  }

  Future<List<NoteModel>> fetchNotes(String userId) async {
    final snapshot = await _userNotesCollection(userId)
        .orderBy('updatedAt', descending: true)
        .get();
    return snapshot.docs
        .map((doc) => NoteModel.fromFirestore(doc.data()))
        .toList();
  }

  Future<void> saveNote(NoteModel note) async {
    await _userNotesCollection(note.userId)
        .doc(note.id)
        .set(note.toFirestore(), SetOptions(merge: true));
  }

  Future<void> deleteNote(String userId, String noteId) async {
    await _userNotesCollection(userId).doc(noteId).delete();
  }
}
